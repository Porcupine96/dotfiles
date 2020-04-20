;; -*- no-byte-compile: t; -*-
;;; ~/.doom.d/packages.el


;; ADD PACKAGES

(package! helm :disable t)
(package! zoom-window)
(package! reason-mode)
(package! string-inflection)
(package! ob-ammonite)
(package! ox-reveal)
(package! keychain-environment)
(package! flycheck-mypy)
(package! flycheck-joker)
(package! vlf)
(package! org-fancy-priorities)
(package! org-re-reveal)
(package! org-super-agenda)
(package! org-pomodoro)
(package! org-jira)

(package! prettier-js)
(package! emojify)

(package! org-ref)

;; (package! helm-bibtex
;;   :recipe (:host github :repo "tmalsburg/helm-bibtex") :pin "3cff6bd702e61ed658ada07c88b7550d0dd836fd")

;; DISABLE PACKAGES

;;data
(package! dhall-mode :disable t)

;;docker
(package! docker :disable t)

;;web
(package! haml-mode :disable t)
(package! pug-mode :disable t)
(package! slim-mode :disable t)
(package! sass-mode :disable t)
(package! sws-mode :disable t)
(package! less-css-mode :disable t)

;;magit
(package! magit-gitflow :disable t)
