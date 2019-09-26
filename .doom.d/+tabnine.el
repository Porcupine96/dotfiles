;;; ~/dotfiles/.doom.d/+tabnine.el -*- lexical-binding: t; -*-

(add-to-list 'company-backends #'company-tabnine)

(setq company-idle-delay 0)
(setq company-show-numbers t)

(defun +tabnine/tabnine-complete ()
    (interactive)
    (company-begin-backend #'company-tabnine))
