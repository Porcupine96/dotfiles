vim.g.mapleader = " "
vim.opt.clipboard:append("unnamedplus")
vim.opt.relativenumber = true
vim.opt.textwidth = 120
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- The colourscheme follows the terminal's background.
--
-- pcode answers OSC 11 with the theme in force and pushes a fresh report on
-- every toggle, so `&background` is correct before this file runs and changes
-- while nvim is open. Two things stop that being enough on its own: dracula is
-- dark-only, and its `set background=dark` makes nvim *delete* its own OSC 11
-- handler at VimEnter -- so the handler below is that rule kept under our
-- control rather than nvim's.
--
-- Swapping either scheme is one line.
local DARK_SCHEME = "dracula"
local LIGHT_SCHEME = "default"

-- Leave the window's background unpainted so the terminal's own shows through.
-- In pcode that is the app's `--bg` exactly, and it repaints on a theme toggle
-- with nvim never learning anything happened. Re-applied on every colourscheme
-- load, including the implicit re-source `set background` triggers.
vim.g.dracula_colorterm = 0
vim.api.nvim_create_autocmd("ColorScheme", {
  desc = "Keep the terminal's own background",
  callback = function()
    for _, group in ipairs({ "Normal", "NormalNC", "SignColumn", "EndOfBuffer" }) do
      vim.cmd(("highlight %s guibg=NONE ctermbg=NONE"):format(group))
    end
  end,
})

-- The scheme is loaded *before* `background` is set, and that order is
-- load-bearing. Setting `background` re-sources whatever scheme is current, and
-- dracula's own `set background=dark` then drags it straight back -- so setting
-- it first leaves a light terminal showing the dark half of the light scheme.
-- Loading dracula, by contrast, sets `background` itself, which is why the
-- assignment below is usually a no-op on the way into the dark theme.
local function apply_background(bg)
  local want = bg == "light" and LIGHT_SCHEME or DARK_SCHEME
  if vim.g.colors_name ~= want then
    pcall(vim.cmd.colorscheme, want)
  end
  if vim.o.background ~= bg then
    vim.o.background = bg
  end
end

vim.api.nvim_create_autocmd("TermResponse", {
  desc = "Follow the terminal's background colour, reported as OSC 11",
  nested = true,
  callback = function(ev)
    local seq = type(ev.data) == "table" and ev.data.sequence or nil
    if type(seq) ~= "string" then
      return
    end
    local r, g, b = seq:match("^\27%]11;rgb:(%x+)/(%x+)/(%x+)$")
    if not r then
      return
    end
    -- Each channel is 1 to 4 hex digits, scaled by its own width.
    local function channel(c)
      return tonumber(c, 16) / tonumber(string.rep("f", #c), 16)
    end
    local luminance = 0.299 * channel(r) + 0.587 * channel(g) + 0.114 * channel(b)
    apply_background(luminance < 0.5 and "dark" or "light")
  end,
})

require("lazy").setup({
  {
    "dracula/vim",
    name = "dracula",
    lazy = false,
    priority = 1000,
    config = function()
      apply_background(vim.o.background)
    end,
  },

  "tpope/vim-surround",

  {
    "hat0uma/csvview.nvim",
    config = true,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local insert_path = function(prompt_bufnr)
        local entry = require("telescope.actions.state").get_selected_entry()
        require("telescope.actions").close(prompt_bufnr)
        local path = entry.path or entry.filename or entry.value
        vim.api.nvim_put({ vim.fn.fnamemodify(path, ":.") }, "c", true, true)
      end
      require("telescope").setup({
        defaults = require("telescope.themes").get_ivy({
          mappings = {
            i = { ["<C-y>"] = insert_path },
            n = { ["<C-y>"] = insert_path },
          },
        }),
      })
      require("telescope").load_extension("fzf")
    end,
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()

      vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
      vim.keymap.set("n", "<leader>e", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
      vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
      vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
      vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
      vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)
    end,
  },

  {
    "mason-org/mason.nvim",
    config = true,
  },

  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({ ensure_installed = { "pyright" } })
      vim.lsp.enable("pyright")
    end,
  },

  "neovim/nvim-lspconfig",

  {
    "scalameta/nvim-metals",
    ft = { "scala", "sbt", "java" },
    config = function()
      local metals_config = require("metals").bare_config()
      metals_config.settings = {
        serverVersion = "2.0.0-M8",
      }
      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "scala", "sbt", "java" },
        callback = function()
          require("metals").initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
        }),
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = { "python", "markdown", "markdown_inline" },
      })
    end,
  },

  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          python = { "ruff_format" },
          scala = { "scalafmt" },
        },
        format_on_save = {
          timeout_ms = 5000,
          lsp_fallback = true,
        },
      })
    end,
  },

  {
    "github/copilot.vim",
    config = function()
      vim.keymap.set("i", "<M-w>", "<Plug>(copilot-accept-word)")
      vim.keymap.set("i", "<C-Tab>", "<Plug>(copilot-accept-word)")
      vim.keymap.set("i", "<M-h>", "<Plug>(copilot-previous)")
      vim.keymap.set("i", "<M-l>", "<Plug>(copilot-next)")
    end,
  },

  {
    "ggml-org/llama.vim",
    init = function()
      vim.g.llama_config = {
        -- The FIM suffix sits after the cursor in the prompt, so every edit
        -- invalidates its KV cache and it is re-processed on each request.
        -- Measured on M3 Pro / Qwen2.5-Coder-3B: 64 lines costs ~1.07s per
        -- completion, 16 lines ~0.81s, 0 lines ~0.45s.
        n_prefix = 256,
        n_suffix = 16,
        n_predict = 128,
        t_max_prompt_ms = 500,
        t_max_predict_ms = 500,
        -- 16 chunks means a ~23s stall the first time the ring buffer fills.
        ring_n_chunks = 8,
        show_info = 2,
        auto_fim = true,
        -- Copilot owns <Tab> until <leader>lt switches engines.
        enable_at_startup = false,
        -- Defaults are <C-J>/<C-K>; <C-K> is signature_help in insert mode.
        keymap_fim_next = "<M-n>",
        keymap_fim_prev = "<M-p>",
        -- These two are mapped in normal mode while the plugin is enabled, and
        -- unmapped again on disable. Left at their defaults of <Tab> and <Esc>
        -- they would shadow <C-i> in the jumplist and delete the nohlsearch
        -- mapping below.
        keymap_inst_accept = "<leader>lla",
        keymap_inst_cancel = "<leader>llx",
      }
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    config = true,
  },

  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    config = true,
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      sign = { enabled = false },
    },
    config = function(_, opts)
      require("render-markdown").setup(opts)
      local ok, ui = pcall(require, "render-markdown.core.ui")
      if ok and ui.updater and ui.updater.run then
        local run = ui.updater.run
        ui.updater.run = function(self)
          local success, err = pcall(run, self)
          if not success and not tostring(err):find("Index out of bounds") then
            error(err, 0)
          end
        end
      end
    end,
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = "cd app && ./install.sh",
  },

  {
    "folke/zen-mode.nvim",
    opts = {
      window = { width = 130 },
    },
  },

  {
    'fei6409/log-highlight.nvim',
    opts = {},
  }
})

-- Markdown folding
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.opt_local.foldlevel = 99
  end,
})

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Window close
vim.keymap.set("n", "<C-w>d", "<C-w>c")

-- Move lines
vim.keymap.set("n", "<M-j>", "<cmd>m .+1<cr>==")
vim.keymap.set("n", "<M-k>", "<cmd>m .-2<cr>==")

-- Delete the previous word
vim.keymap.set("i", "<M-BS>", "<C-w>")

-- LSP
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gi", vim.diagnostic.open_float)
vim.keymap.set("n", "gr", vim.lsp.buf.references)
vim.keymap.set("n", "gR", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "gt", vim.lsp.buf.type_definition)
vim.keymap.set("n", "gI", vim.lsp.buf.implementation)
vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help)

-- Telescope
-- live_grep hands the prompt to rg as a single regex, so "COLD ENABLED" searches
-- for that literal string. Split the prompt on whitespace instead and AND the
-- terms together with PCRE2 lookaheads, so they can match anywhere on the line
-- in any order. A leading "!" negates a term, mirroring the fzf syntax the
-- sorter already accepts.
local function grep_pattern(prompt)
  local terms = {}
  for term in prompt:gmatch("%S+") do
    terms[#terms + 1] = term
  end
  if #terms == 0 then
    return nil, false
  end
  -- A single positive term is already a valid regex, so leave it on rg's default
  -- engine, which is faster than PCRE2 over a big tree.
  if #terms == 1 and terms[1]:sub(1, 1) ~= "!" then
    return terms[1], false
  end
  local parts = {}
  for _, term in ipairs(terms) do
    if term:sub(1, 1) == "!" then
      if #term > 1 then
        parts[#parts + 1] = "(?!.*" .. term:sub(2) .. ")"
      end
    else
      parts[#parts + 1] = "(?=.*" .. term .. ")"
    end
  end
  return table.concat(parts), true
end

-- The stock grep highlighter fuzzy-matches the whole prompt against the result
-- line, which is meaningless once the prompt is a set of terms. Highlight each
-- term's own occurrences instead.
local function highlight_grep_terms(_, prompt, display)
  local positions = {}
  local haystack = display:lower()
  for term in prompt:gmatch("%S+") do
    if term:sub(1, 1) ~= "!" then
      local needle, init = term:lower(), 1
      while true do
        local s, e = haystack:find(needle, init, true)
        if not s then
          break
        end
        positions[#positions + 1] = { start = s, finish = e }
        init = e + 1
      end
    end
  end
  return positions
end

local function live_grep_terms(opts)
  opts = opts or {}
  local conf = require("telescope.config").values
  local finders = require("telescope.finders")
  local make_entry = require("telescope.make_entry")
  local pickers = require("telescope.pickers")
  local sorters = require("telescope.sorters")

  opts.cwd = opts.cwd or vim.uv.cwd()

  local sorter = sorters.highlighter_only(opts)
  sorter.highlighter = highlight_grep_terms

  local finder = finders.new_job(function(prompt)
    if not prompt or prompt == "" then
      return nil
    end
    local pattern, needs_pcre2 = grep_pattern(prompt)
    if not pattern then
      return nil
    end
    local args = vim.deepcopy(conf.vimgrep_arguments)
    if needs_pcre2 then
      args[#args + 1] = "--pcre2"
    end
    args[#args + 1] = "--"
    args[#args + 1] = pattern
    return args
  end, make_entry.gen_from_vimgrep(opts), opts.max_results, opts.cwd)

  pickers
    .new(opts, {
      prompt_title = "Live Grep (all terms)",
      finder = finder,
      previewer = conf.grep_previewer(opts),
      sorter = sorter,
      attach_mappings = function(_, map)
        map("i", "<c-space>", require("telescope.actions").to_fuzzy_refine)
        return true
      end,
      push_cursor_on_edit = true,
    })
    :find()
end

vim.keymap.set("n", "<C-s>", function()
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  require("telescope.builtin").current_buffer_fuzzy_find({
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        local picker = action_state.get_current_picker(prompt_bufnr)
        local prompt = picker:_get_prompt()
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if entry then
          vim.api.nvim_win_set_cursor(0, { entry.lnum, 0 })
          vim.cmd("normal! ^")
        end
        if prompt ~= "" then
          -- fzf-native treats the prompt as separate terms, so searching for it
          -- verbatim would find nothing. Highlight the terms as alternatives.
          local terms = {}
          for term in prompt:gmatch("%S+") do
            terms[#terms + 1] = vim.fn.escape(term, "\\")
          end
          vim.fn.setreg("/", "\\V\\(" .. table.concat(terms, "\\|") .. "\\)")
          vim.opt.hlsearch = true
        end
      end)
      return true
    end,
  })
end)
vim.keymap.set("n", "<leader>bb", "<cmd>Telescope buffers<cr>")
vim.keymap.set("n", "<leader><leader>", "<cmd>Telescope find_files<cr>")
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
vim.keymap.set("n", "<leader>pf", function() live_grep_terms() end)
vim.keymap.set("n", "<leader>fg", function() live_grep_terms() end)
vim.keymap.set("n", "<leader>,", function()
  live_grep_terms({ cwd = vim.fn.expand("%:p:h") })
end)
-- Stock single-regex live grep, for when a term contains spaces.
vim.keymap.set("n", "<leader>fG", "<cmd>Telescope live_grep<cr>")
vim.keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>")
vim.keymap.set("n", "<leader>gl", "<cmd>Telescope git_commits<cr>")
vim.keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>")

-- Gitsigns
vim.keymap.set("n", "<leader>gB", "<cmd>Gitsigns blame<cr>")
vim.keymap.set("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>")
vim.keymap.set("n", "]h", "<cmd>Gitsigns next_hunk<cr>")
vim.keymap.set("n", "[h", "<cmd>Gitsigns prev_hunk<cr>")

-- Neogit
vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>")

-- Conform
vim.keymap.set("n", "<leader>lf", function() require("conform").format({ timeout_ms = 5000 }) end)

-- Completion engine: Copilot and llama.vim both draw ghost text and both bind
-- <Tab>, so exactly one of them is active at a time.
local llama_active = false
vim.keymap.set("n", "<leader>lt", function()
  if llama_active then
    vim.cmd("LlamaDisable")
    vim.cmd("Copilot enable")
    -- llama.vim binds <Tab> buffer-locally, but its own source flags these
    -- unmaps as unreliable, so put Copilot's back if it went missing.
    if vim.fn.maparg("<Tab>", "i") == "" then
      vim.cmd([[imap <script><silent><nowait><expr> <Tab> copilot#Accept()]])
    end
    llama_active = false
    vim.notify("Copilot on, llama.vim off")
  else
    vim.cmd("Copilot disable")
    vim.cmd("LlamaEnable")
    llama_active = true
    vim.notify("llama.vim on (local), Copilot off")
  end
end, { desc = "Toggle between Copilot and llama.vim" })
vim.keymap.set("n", "<leader>ls", "<cmd>LlamaStatus<cr>", { desc = "llama.vim server status" })

-- Two completion models: the stock coder on 8012, and one fine-tuned on my own
-- prompts on 8013. llama.vim reads endpoint_fim per request, so picking by
-- filetype is enough to route between them.
local PROSE_FILETYPES = {
  markdown = true, text = true, gitcommit = true, org = true,
  rst = true, tex = true, mail = true, [""] = true,
}
vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
  group = vim.api.nvim_create_augroup("llama_endpoint_by_filetype", { clear = true }),
  callback = function(args)
    local port = PROSE_FILETYPES[vim.bo[args.buf].filetype] and 8013 or 8012
    vim.g.llama_config = vim.tbl_extend("force", vim.g.llama_config, {
      endpoint_fim = ("http://127.0.0.1:%d/infill"):format(port),
    })
  end,
})

-- Zen Mode
vim.keymap.set("n", "<leader>zz", "<cmd>ZenMode<cr>")

-- Markdown preview
vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>")

-- Misc
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>")
vim.keymap.set("n", "<leader>cr", "<cmd>source $MYVIMRC<cr>")
vim.keymap.set("n", "<leader>fc", "<cmd>edit $MYVIMRC<cr>")
vim.keymap.set("n", "<leader>yp", function() vim.fn.setreg("+", vim.fn.expand("%:p")) end)
vim.keymap.set("n", "<leader>bN", function()
  vim.cmd("enew")
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "hide"
  vim.bo.swapfile = false
end)
vim.keymap.set("n", "<C-x>j", "<cmd>Explore %:p:h<cr>")
vim.keymap.set("n", "<C-x><C-j>", "<cmd>Explore %:p:h<cr>")
