;;; theme.el --- My custom theme setup -*- lexical-binding: t; -*-
;;; Commentary:
;;; generated.el (matugen palette) only *defines* `apply-matugen-colors' here;
;;; the colors are applied after `load-theme' has run, so the two no longer
;;; race through a timer.
;;; Code:

(defvar my/matugen-colors-file
  (expand-file-name "~/.config/emacs/generated.el")
  "Matugen-generated palette, applied on top of the base theme.")

(when (file-exists-p my/matugen-colors-file)
  (load-file my/matugen-colors-file))

;; Use spacemacs theme
(use-package spacemacs-theme
  :ensure t
  :config
  (setq spacemacs-theme-comment-bg nil)
  (setq spacemacs-theme-comment-italic t)
  (setq spacemacs-theme-org-agenda-height nil)
  (setq spacemacs-theme-org-height nil)
  (load-theme 'spacemacs-dark t))

;; Overlay the matugen palette on top of the theme, deterministically.
(when (fboundp 'apply-matugen-colors)
  (apply-matugen-colors))

;; nerd icons
(use-package nerd-icons :ensure t)

;; modeline from doom emacs
(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode)
  :config
  (setq doom-modeline-project-detection 'projectile)
  (setq find-file-visit-truename t))

;; Better floating windows
(use-package popwin :ensure t :init (popwin-mode 1))

(provide 'theme)
;;; theme.el ends here
