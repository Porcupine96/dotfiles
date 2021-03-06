;;; ~/.doom.d/+scala.el -*- lexical-binding: t; -*-


(defun +scala/copy-import ()
    (interactive)
    (setq import
      (replace-regexp-in-string "package" "import"
      (concat
        (car (split-string (buffer-string) "\n"))
        "."
        (thing-at-point 'word))))

    (message "Copied: %s" import)
    (kill-new import))


(defun +scala/package ()
  (interactive)
  (let* ((dir-path (file-name-directory buffer-file-name))
        (package-part (last (split-string dir-path "scala"))))
        (pcase package-part
          ('nil (message "Cannot resolve the package"))
          (_ (let* ((parts (replace-regexp-in-string "/" " " (car package-part)))
                    (package (replace-regexp-in-string " " "." (string-trim parts))))
               package)))))


(defun +scala/search-symbol (symbol)
  (let ((counsel-projectile-ag-initial-input (format "%s " symbol)))
       (counsel-projectile-ag)))


(defun +scala/search-class ()
  (interactive)
  (+scala/search-symbol "class"))

(defun +scala/search-case-class ()
  (interactive)
  (+scala/search-symbol "case class"))

(defun +scala/search-def ()
  (interactive)
  (+scala/search-symbol "def"))

(defun +scala/search-object ()
  (interactive)
  (+scala/search-symbol "object"))


(defun +scala/referse-pattern-match ()
  (interactive)
  (let (pattern (evil-ex-make-search-pattern "x"))
    (evil-ex-substitute "'<" "'>" pattern "y")
    ))


(after! scala-mode
  (map!
  (:leader
    (:prefix "l"
      :map scala-mode-map
      :desc "lsp-ui-flycheck-list" :nv "e" #'lsp-ui-flycheck-list
      :desc "search-class" :nv "c" #'+scala/search-class
      :desc "search-case-class" :nv "v" #'+scala/search-case-class
      :desc "search-def" :nv "d" #'+scala/search-def
      :desc "search-object" :nv "o" #'+scala/search-object
      :desc "copy-import" :nv "i" #'+scala/copy-import
      :desc "lsp-find-workspace-symbol" :nv "l" #'lsp-ui-find-workspace-symbol))))
