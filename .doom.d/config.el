;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; VISUALS {{{

(load-theme 'doom-solarized-light t)

(add-hook 'doom-load-theme-hook
          (lambda ()
            (require 'treemacs)
            (treemacs-load-theme "Default")))

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
                      :height 1.1))

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
 ))

;; workspace movements
(map! :map evil-window-map
      "d" #'+workspace/close-window-or-workspace
      "c" nil
      "[" #'+workspace/switch-left
      "]" #'+workspace/switch-right
      "C-o" #'zoom-window-zoom)

;; (global-set-key (kbd "SPC-`") #'+workspace/other)

;; python
(map! :map python-mode-map
      "C-c C-o" #'run-python)

;; }}}


;; MISC {{{

(setq
;; global mar
 global-mark-ring-max 16
;; treemacs config
 treemacs-width 50
;; projectile config
 projectile-project-search-path '("~/codeheroes/")
;; turn off continuing comments
 +evil-want-o/O-to-continue-comments nil
;; relative line numbers
 display-line-numbers-type 'relative)

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
;; }
