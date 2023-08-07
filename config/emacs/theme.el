;;; my-main --- My custom theme setup
;;; Commentary:
;;; none

;;; Code:

;; ;; Use spacemacs theme
;; (use-package
;;   spacemacs-theme
;;   :config
;;   ;; Do not use a different background color for comments.
;;   (setq spacemacs-theme-comment-bg nil)

;;   ;; Comments should appear in italics.
;;   (setq spacemacs-theme-comment-italic t)

;;   ;; Use the `spacemacs-dark` theme.
;;   (load-theme 'spacemacs-dark))

;; Solarized theme
;; (use-package
;;   solarized-theme
;;   :ensure t
;;   :config
;;   (load-theme 'solarized-dark t))

;; Doom emacs themes
(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (setq doom-oceanic-next-brighter-comments t)
  (load-theme 'doom-oceanic-next t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  ;; (doom-themes-neotree-config)
  ;; or for treemacs users
  ;; (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  ;; (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

;; nerd icons
(use-package nerd-icons
  :ensure t)

;; modeline from doom emacs
(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode)
  :config
  (setq doom-modeline-project-detection 'projectile)
  (setq find-file-visit-truename t))

;; ;; A nice looking modeline enhancement
;; (use-package spaceline
;;   :ensure t)

;; ;; Add some visual flair to the modeline enhancements
;; (use-package spaceline-all-the-icons
;;   :ensure t
;;   :after spaceline
;;   :config (spaceline-all-the-icons-theme)
;;   (spaceline-all-the-icons--setup-neotree)
;;   (spaceline-emacs-theme))

;; (use-package
;;   smart-mode-line
;;   :ensure t
;;   :init
;;   (sml/setup))

;; Auto dim other window
(use-package
  auto-dim-other-buffers
  :ensure t
  :init
  ;; Automatically dim other windows
  (auto-dim-other-buffers-mode t))
