;;; edit.el --- General editing -*- lexical-binding: t; -*-
;;; Code:

;; Enable mode that automatically inserts parenthesis
;; but that is much less annoying
(electric-pair-mode)

;; Multiple cursors
(use-package multiple-cursors
  :ensure t
  :bind
  (("C-M-n" . mc/mark-next-like-this)
   ("C-M-p" . mc/mark-previous-like-this)))

;; iedit -- edit multiple similar places
(use-package iedit :ensure t :defer t)

;; vterm -- used by Projectile
(use-package vterm :ensure t :defer t)

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode
  (("README\\.md\\'" . gfm-mode)
   ("\\.md\\'" . gfm-mode)
   ("\\.markdown\\'" . markdown-mode))
  :init
  (setq markdown-command "multimarkdown")
  (add-hook 'markdown-mode-hook 'auto-fill-mode)
  (add-hook 'markdown-mode-hook 'flyspell-mode))

(use-package move-text
  :ensure t
  :bind
  (:map global-map
        ("M-p" . move-text-up)
        ("M-n" . move-text-down)))

(use-package visual-fill-column
  :ensure t
  :defer t
  :config
  (add-hook 'visual-line-mode-hook #'visual-fill-column-mode)
  (setq-default visual-fill-column-center-text t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Quality of Life Packages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Avy - Jump anywhere quickly
(use-package avy
  :ensure t
  :bind
  (("C-'" . avy-goto-char-2)
   ("C-:" . avy-goto-line))
  :config
  (setq avy-background t)
  (setq avy-style 'at-full))

;; Helpful - Better help buffers
(use-package helpful
  :ensure t
  :bind
  (("C-h f" . helpful-callable)
   ("C-h v" . helpful-variable)
   ("C-h k" . helpful-key)
   ("C-h x" . helpful-command)))

;; Undo: using the built-in linear undo/redo.  `C-/' undoes, `C-?' (or M-_)
;; redoes via `undo-redo'.  undo-tree was dropped -- it is unmaintained since
;; 2021.  If the visual tree is missed, `vundo' is the modern replacement.

(provide 'edit)
;;; edit.el ends here
