;; setup packages
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/"))

;; (unless package-archive-contents
;;   (package-refresh-contents))

;; (setq package-load-list '(all))
;; (unless (package-installed-p 'org)
;;   (package-install 'org))

(package-initialize)

;; those lines were added during the evil installation
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (helm-swoop ample-theme org evil))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; PACKAGES {{

;; Helm
(require 'helm-config)
(require 'helm-swoop)

;; In order to make the "tab" key behave correctly in helm-find-files
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)

(global-set-key (kbd "C-x b") 'helm-buffers-list)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "M-f") 'helm-swoop)

;; }}


;; KEYBINDINGS {{

(defun open-config ()
  (interactive)
  (find-file "~/.emacs.d/init.el"))

(defun reload-current-file ()
  (interactive)
  (load-file buffer-file-name))
 
;; Working with the configuration file
(global-set-key (kbd "C-c c") 'open-config)
(global-set-key (kbd "C-c r") 'reload-current-file)

;; Easier splitting
;; (global-set-key (kbd "SPC w |") 'split-window-right)
;; (global-set-key (kbd "C-w -") 'split-window-below)

;; Easier moving between splits 
(global-set-key (kbd "C-h") 'evil-window-left)
(global-set-key (kbd "C-j") 'evil-window-down)
(global-set-key (kbd "C-k") 'evil-window-up)
(global-set-key (kbd "C-l") 'evil-window-right)

;; Easier saving hte file
(global-set-key (kbd "C-s") 'save-buffer)

;; }}

;; VIEW {{

(load-theme 'ample t t)
(enable-theme 'ample)

(tool-bar-mode -1)
(menu-bar-mode -1)
(toggle-scroll-bar -1)

;; }}


;; turn on evil mode by default
(require 'evil)
(evil-mode 1)
