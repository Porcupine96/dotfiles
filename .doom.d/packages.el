;; -*- no-byte-compile: t; -*-
;;; ~/.doom.d/packages.el


;; ADD PACKAGES

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
(package! org-super-agenda)
(package! org-re-reveal)

(package! org-jira)

(package! prettier-js)
(package! emojify)

(package! org-ref)

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

;;helm
(package! helm)

;;magit
(package! magit-gitflow :disable t)
