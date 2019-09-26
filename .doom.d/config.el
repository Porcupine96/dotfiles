;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; temporary
(setq elfeed-db-directory "~/Dropbox/rss/elfeeddb")
(setq rmh-elfeed-org-files (list "~Dropbox/rss/elfeed.org"))

;; VISUALS {{{

;; theme
(load-theme 'doom-solarized-light t)

;; treemacs icons
(add-hook 'doom-load-theme-hook
          (lambda ()
            (require 'treemacs)
            (treemacs-load-theme "Default")))

;; org mode
(setq
  org-ellipsis " ▾ "
  org-bullets-bullet-list '("⁖")
  org-refile-targets (quote ((nil :maxlevel . 1)))
  org-tags-column -40)

(custom-set-faces
 '(org-level-1 ((t nil))))

(after! org
  (set-face-attribute 'org-document-title nil
                      :foreground "grey"
                      :background nil
                      :height 1.5
                      :weight 'bold)
  (set-face-attribute 'org-level-1 nil
                      :foreground "steelblue2"
                      :box nil
                      :background nil
                      :height 1.2
                      :weight 'bold)
  (set-face-attribute 'org-level-2 nil
                      :foreground nil
                      :background nil
                      :height 1.1)
  (org-babel-do-load-languages
    'org-babel-load-languages
    '((emacs-lisp . t)
      (python . t)
      (java . t)
      (shell . t)
      (C . t)
      (sql . t)
      (ammonite . t)
      )))

;; }}}

(defun kitty ()
    (interactive)
    (require 'subr-x)
    (start-process "RUN" "RUN" "kitty" "-d" doom-modeline-project-root))

;; }}}

;; KEYBINDINGS {{{

;; use swiper instead of ISearch
(global-set-key (kbd "C-s") 'swiper)

;; quick way to save a buffer
(global-set-key (kbd "C-x C-x") 'save-buffer)

;; easier movements between splits
(global-set-key (kbd "C-h") 'evil-window-left)
(global-set-key (kbd "C-j") 'evil-window-down)
(global-set-key (kbd "C-k") 'evil-window-up)
(global-set-key (kbd "C-l") 'evil-window-right)

;; prevent org-mode from overriding the global map
(map! :map org-mode-map
      "C-j" 'evil-window-down)

;; leader movements
(map!
 (:leader
   (:prefix "c"
     :desc "Cheatsheet" :n "s" #'(find-file "~/Dropbox/org/knowledge/cheatsheet.org"))
   (:prefix "p"
     :desc "projectile-ag" :n "f" #'projectile-ag)
   (:prefix "l"
     :desc "lsp" :prefix "l"
     :desc "format-buffer" :nv "f" #'lsp-format-buffer)
   (:prefix "o"
     :desc "eshell" :nv "e" #'eshell)
   (:prefix "TAB"
     :desc "Display tab bar" :nv "`" #'+workspace/display
     :desc "Switch to last workpace" :nv "TAB" #'+workspace/other)
 ))

;; workspace movements
(map! :map evil-window-map
      "d" #'+workspace/close-window-or-workspace
      "c" nil
      "[" #'+workspace/switch-left
      "]" #'+workspace/switch-right
      "C-o" #'zoom-window-zoom)

;; completion
(map! :map evil-insert-state-map
      "C-n" #'+company/dabbrev
      "C-p" #'+company/dabbrev-code-previous
      "C-m" #'+tabnine/tabnine-complete)

;; python
(map! :map python-mode-map
      "C-c C-o" #'run-python)

;; }}}


;; MISC {{{

(setq
;; initial buffer
 initial-buffer-choice "~/Dropbox/org/todo/current.org"
;; global mark
 global-mark-ring-max 16
;; treemacs config
 treemacs-width 50
;; projectile config
 projectile-project-search-path '("~/codeheroes/")
;; turn off continuing comments
 +evil-want-o/O-to-continue-comments nil
;; relative line numbers
 display-line-numbers-type 'relative)

(global-auto-revert-mode t)

;; company
(after! company
  (setq company-idle-delay 0.1))

;; org-mode
(after! org
  (setq
    org-log-done 'time))
;; }}}

;; python
(def-package! blacken-mode
  :hook
  (python-mode . blacken-mode))

;; ADDITIONAL MODULES {{{
(load! "+reason")
(load! "+scala")
(load! "+blacken")
(load! "+tabnine")
;; (load! "+elfeed")
;; }
