;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; temporary
;; (setq elfeed-db-directory "~/Dropbox/rss/elfeeddb")
;; (setq rmh-elfeed-org-files (list "~Dropbox/rss/elfeed.org"))

;; VISUALS {{{

;; theme
;; (load-theme 'doom-solarized-light t)
;; (load-theme 'doom-dracula t)
;; (load-theme 'doom-nord t)
(load-theme 'porcupine-light t)

(setq
  doom-font (font-spec :family "SF Mono" :size 32)
  doom-big-font (font-spec :family "SF Mono" :size 42))

(custom-set-faces
  '(mode-line ((t (:family "SF Mono" :height 1.0))))
  '(mode-line-inactive ((t (:family "SF Mono" :height 1.0)))))

;; (setq doom-font (font-spec :family "Hack" :size 28))
;; (setq doom-font (font-spec :family "FiraCode Nerd Font Mono" :size 28))

;; zoom window
(custom-set-variables
 '(zoom-window-mode-line-color "DarkGreen")
 '(zoom-window-use-persp t))

;; toggle scroll and menu bars
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

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

(use-package! org-fancy-priorities
  :hook (org-mode . org-fancy-priorities-mode)
  :config
  (setq
   org-highest-priority 65
   org-fancy-priorities-list '("" "" "")))

(use-package! org-super-agenda
  :hook (org-agenda-mode . org-super-agenda-mode)
  :config
  (setq
   org-super-agenda-groups '((:name "Today"
                                    :time-grid t
                                    :scheduled today)
                             (:name "Due today"
                                    :deadline today)
                             (:name "Important"
                                    :priority "A")
                             (:name "Overdue"
                                    :deadline past)
                             (:name "Due soon"
                                    :deadline future))))

;; magit
(after! magit
  (setq git-commit-style-convention-checks
        (remove 'overlong-summary-line git-commit-style-convention-checks)))

;; }}}

;; FUNCTIONS {{{

(defun kitty ()
    (interactive)
    (require 'subr-x)
    (start-process "RUN" "RUN" "kitty" "-d" doom-modeline-project-root))

;; }}}

;; KEYBINDINGS {{{

;; agenda
(global-set-key (kbd "<f1>") #'org-agenda)

;; use swiper instead of ISearch
(global-set-key (kbd "C-s") 'swiper)

;; quick way to save a buffer
(global-set-key (kbd "C-x C-x") 'save-buffer)

;; easier movements between splits
(global-set-key (kbd "C-h") #'evil-window-left)
(global-set-key (kbd "C-j") #'evil-window-down)
(global-set-key (kbd "C-k") #'evil-window-up)
(global-set-key (kbd "C-l") #'evil-window-right)


(global-set-key (kbd "C-c m u") #'smerge-keep-upper)
(global-set-key (kbd "C-c m l") #'smerge-keep-lower)

;; buffer movements
;; (global-set-key (kbd "C-[") #'previous-buffer)
;; (global-set-key (kbd "C-]") #'next-buffer)

;; avy
(setq avy-timeout-seconds 0.25)

;; treemacs
(global-set-key (kbd "M-p") #'+treemacs/toggle)

(defun +treemacs/copy-rename ()
  (interactive)
  (treemacs-copy-file)
  (treemacs-rename))

(after! treemacs
  (require 'treemacs)
  (treemacs-load-theme "Default")
  (setq treemacs-follow-mode 't)
  (map! :map evil-treemacs-state-map "M-p" #'+treemacs/toggle)
  (map! :map treemacs-mode-map "M-p" #'+treemacs/toggle)
  (map! :map treemacs-mode-map "cc" #'+treemacs/copy-rename))

;; jk to switch to normal-mode
(setq-default evil-escape-key-sequence "jk")

;; C-j and C-k to move between panes

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
     :desc "ranger" :nv "r" #'ranger
     :desc "deer" :nv "d" #'deer)
   (:prefix "TAB"
     :desc "Display tab bar" :nv "`" #'+workspace/display
     :desc "Switch to last workpace" :nv "TAB" #'+workspace/other)
   (:prefix "e"
     :desc "elfeed" :nv "e" #'elfeed)
   (:nv "k" #'helm-show-kill-ring)
 ))


;; workspace movements
(map! :map evil-window-map
      "d" #'+workspace/close-window-or-workspace
      "c" nil
      "[" #'+workspace/switch-left
      "]" #'+workspace/switch-right
      "C-o" #'zoom-window-zoom
      "p" #'+treemacs/toggle
      "|" #'clone-indirect-buffer-other-window)

;; evil
(map! :map evil-insert-state-map
      "C-n" #'+company/dabbrev
      "C-p" #'+company/dabbrev-code-previous)

;; evil
(map! :map evil-normal-state-map
      "U" #'lsp-ui-doc-glance
      "g i" #'lsp-find-implementation)

;; python
(map! :map python-mode-map
      "C-c C-o" #'run-python
      "C-c c" #'recompile)

;; ruby
(map! :map enh-ruby-mode-map
      "C-j" 'evil-window-down)

;; company
(map! :map company-mode-map
  :i "C-S-SPC" #'company-tabnine)

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

;; (add-hook 'org-insert-heading-hook
;;   (lambda ()
;;     (message "Hello from: org-mode-hook")

;;     (map! :map org-mode-map
;;           "C-k" #'evil-window-up
;;           "C-j" #'evil-window-down)

;;     (map! :map evil-org-mode-map
;;           :ni "C-k" #'evil-window-up
;;           :ni "C-j" #'evil-window-down)))

;; }}}

;; MISC {{{

(setq
 auth-sources '("~/.authinfo")
 ;; fix clipboard manager issue
 x-select-enable-clipboard-manager nil
;; initial buffer
 initial-buffer-choice "~/Dropbox/org/todo/current.org"
;; global mark
 global-mark-ring-max 16
;; treemacs config
 treemacs-width 50
;; projectile config
 projectile-project-search-path '("~/codeheroes/")
 projectile-project-root-files-functions #'(projectile-root-top-down
                                            projectile-root-top-down-recurring
                                            projectile-root-bottom-up
                                            projectile-root-local)
;; turn off continuing comments
 +evil-want-o/O-to-continue-comments nil
;; relative line numbers
 display-line-numbers-type 'relative

 ;; pomodoro
 org-pomodoro-short-break-sound "~/dotfiles/fish.wav"
 org-pomodoro-long-break-sound "~/dotfiles/fish.wav"
 org-pomodoro-finished-sound "~/dotfiles/fish.wav"

 org-pomodoro-format " %s"
 org-pomodoro-short-break-format "  %s"
 org-pomodoro-long-break-format "  %s")


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
(use-package! blacken-mode
  :hook
  (python-mode . blacken-mode))

(setq python-shell-interpreter "ipython"
        python-shell-interpreter-args "--simple-prompt -i")

;; protobuf
(after! protobuf
  (setq tab-width 4))

;; clojure
(after! clojure
    (add-hook 'before-save-hook #'cider-format-buffer))

;; scala
(add-hook 'scala-mode-hook
          #'lsp)

(after! scala
  (add-hook 'before-save-hook #'lsp-format-buffer))

;; protobuf
(defconst my-protobuf-style
  '((c-basic-offset . 4)
    (indent-tabs-mode . nil)))

(add-hook 'protobuf-mode-hook
  (lambda () (c-add-style "my-style" my-protobuf-style t)))

;; use smartparens
(sp-use-smartparens-bindings)

;; resizer-mode
(defvar resizer-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "h") 'evil-window-decrease-width)
    (define-key map (kbd "l") 'evil-window-increase-width)
    map))

(define-minor-mode resizer-mode "A mode for resizing windows."
  :keymap resizer-mode-map)

(global-set-key (kbd "C-c r") #'resizer-mode)

;; elfeed
(setq
 elfeed-root "~/Dropbox/rss/"
 elfeed-db-directory (concat elfeed-root "elfeed/db/")
 elfeed-db-directory (concat elfeed-root "elfeed/enclosures/")
 elfeed-feeds
 '(("https://www.reddit.com/r/i3wm.rss" reddit i3wm)
   ("https://www.reddit.com/r/scala.rss" reddit scala)))

;; jira
;; (setq jiralib-url "https://chatbotize.atlassian.net")

;; plantUML
(setq plantuml-jar-path "/home/porcupine/tool/plantuml.jar")
(setq plantuml-default-exec-mode 'jar)
(setq org-plantuml-jar-path "/home/porcupine/tool/plantuml.jar")

;; }}}

;; ADDITIONAL MODULES {{{
(load! "+reason")
(load! "+scala")
(load! "+blacken")
(load! "+tabnine")
;; }}}

(keychain-refresh-environment)

