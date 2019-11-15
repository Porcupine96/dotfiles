;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; temporary
;; (setq elfeed-db-directory "~/Dropbox/rss/elfeeddb")
;; (setq rmh-elfeed-org-files (list "~Dropbox/rss/elfeed.org"))

;; VISUALS {{{

;; theme
;; (load-theme 'doom-solarized-light t)
;; (load-theme 'doom-dracula t)
(load-theme 'doom-molokai t)

(setq doom-font (font-spec :family "Fira Mono" :size 28))

;; zoom window
(custom-set-variables
 '(zoom-window-mode-line-color "DarkGreen")
 '(zoom-window-use-persp t))

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
  (set-face-attribute 'org-block-begin-line nil
                      :foreground "lightgrey"
                      :box nil
                      :background nil
                      :height 0.8)
  (set-face-attribute 'org-block-end-line nil
                      :foreground "lightgrey"
                      :box nil
                      :background nil
                      :height 1.0)

  (org-babel-do-load-languages
    'org-babel-load-languages
    '((emacs-lisp . t)
      (python . t)
      (java . t)
      (shell . t)
      (C . t)
      (sql . t)
      (ammonite . t)
      (clojure . t)
      )))
;; }}}

;; FUNCTIONS {{{

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
(global-set-key (kbd "C-h") #'evil-window-left)
(global-set-key (kbd "C-j") #'evil-window-down)
(global-set-key (kbd "C-k") #'evil-window-up)
(global-set-key (kbd "C-l") #'evil-window-right)

;; treemacs
(global-set-key (kbd "M-p") #'+treemacs/toggle)

(after! treemacs
  (require 'treemacs)
  (treemacs-load-theme "Default")
  (map! :map evil-treemacs-state-map "M-p" #'+treemacs/toggle)
  (map! :map treemacs-mode-map "M-p" #'+treemacs/toggle))

;; jk to switch to normal-mode
(setq-default evil-escape-key-sequence "jk")

;; prevent org-mode from overriding the global map
(map! :map org-mode-map
      "C-k" #'evil-window-up
      "C-j" #'evil-window-down)

(map! :map evil-org-mode-map
      "C-k" #'evil-window-up
      "C-j" #'evil-window-down)

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
   (:prefix "r"
     :desc "ranger" :nv "r" #'ranger)
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
      "C-o" #'zoom-window-zoom
      "p" #'+treemacs/toggle
      "C-v" #'clone-indirect-buffer-other-window)

;; completion
(map! :map evil-insert-state-map
      "C-n" #'+company/dabbrev
      "C-p" #'+company/dabbrev-code-previous)

;; python
(map! :map python-mode-map
      "C-c C-o" #'run-python)

;; ruby
(map! :map enh-ruby-mode-map
      "C-j" 'evil-window-down)

;; org
(defun org-archive-done ()
  (interactive)
  (org-archive-all-done))

(defun org-archive-save-buffer ()
  (let ((afile (car (org-all-archive-files))))
    (if (file-exists-p afile)
      (let ((buffer (find-file-noselect afile)))
          (with-current-buffer buffer
            (save-buffer)))
      (message "Ooops ... (%s) does not exist." afile))))

(add-hook 'org-archive-hook 'org-archive-save-buffer)

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
  (setq org-log-done 'time)
  (setq org-html-validation-link nil))

;; ox-reveal
(require 'ox-reveal)
(setq org-reveal-root "https://cdn.jsdelivr.net/npm/reveal.js")
(setq Org-Reveal-title-slide nil)

;; python
(def-package! blacken-mode
  :hook
  (python-mode . blacken-mode))

;; clojure
(after! clojure
    (add-hook 'before-save-hook #'cider-format-buffer))

;; scala
(add-hook 'scala-mode-hook
    (add-hook 'before-save-hook #'lsp-format-buffer))

;; use smartparens
(sp-use-smartparens-bindings)

;; }}}

;; ADDITIONAL MODULES {{{
(load! "+reason")
(load! "+scala")
(load! "+blacken")
;; }}}

(keychain-refresh-environment)
