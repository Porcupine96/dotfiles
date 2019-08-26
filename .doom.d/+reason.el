;;; -*- lexical-binding: t; -*-


(def-package! reason-mode
  :mode "\\.rei?$"
  :commands (reason-mode)
  :config
  ;;(setq refmt-command "~/.yarn/bin/bsrefmt")
  (lsp)
  (add-hook! lsp
          (lsp-register-client
          (make-lsp-client :new-connection (lsp-stdio-connection "/home/porcupine/tool/reason-language-server")
                           :major-modes '(reason-mode)
                           :notification-handlers (ht ("client/registerCapability" 'ignore))
                           :priority 1
                           :server-id 'reason-ls))))
