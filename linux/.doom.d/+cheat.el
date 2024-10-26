;;; ~/dotfiles/.doom.d/+cheat.el -*- lexical-binding: t; -*-

(defun cheat-sh (query)
  "Query the https://cheat.sh page and display results."
  (interactive "sQuery: ")
  (require 'ansi-color)
  (switch-to-buffer "*cheat.sh*")
  (erase-buffer)
  (insert (shell-command-to-string
            (format "curl -s https://cheat.sh/%s" query)))
  (ansi-color-apply-on-region (point-min) (point-max)))
