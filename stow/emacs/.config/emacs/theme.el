;;; my-main --- My custom theme setup
;;; Commentary:
;;; none

;;; Code:

;; Load matugen colors FIRST
(let ((matugen-colors (expand-file-name "~/.config/emacs/generated.el")))
  (when (file-exists-p matugen-colors)
    (load-file matugen-colors)
    (apply-matugen-colors)))

;; Use spacemacs theme
(use-package spacemacs-theme
 :ensure t
 :config
 (setq spacemacs-theme-comment-bg nil)
 (setq spacemacs-theme-comment-italic t)
 (setq spacemacs-theme-org-agenda-height nil)
 (setq spacemacs-theme-org-height nil)
 (load-theme 'spacemacs-dark t))

;; Solarized theme
;; (use-package
;;   solarized-theme
;;   :ensure t
;;   :config
;;   (load-theme 'solarized-dark t))

;; Doom emacs themes
;; (use-package doom-themes
;;   :ensure t
;;   :config
;;   ;; Global settings (defaults)
;;   (setq doom-themes-enable-bold t ; if nil, bold is universally disabled
;;         doom-themes-enable-italic t) ; if nil, italics is universally disabled
;;   (setq doom-oceanic-next-brighter-comments t)
;;   (load-theme 'doom-oceanic-next t)

;;   ;; Enable flashing mode-line on errors
;;   (doom-themes-visual-bell-config)
;;   ;; Enable custom neotree theme (all-the-icons must be installed!)
;;   ;; (doom-themes-neotree-config)
;;   ;; or for treemacs users
;;   ;; (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
;;   ;; (doom-themes-treemacs-config)
;;   ;; Corrects (and improves) org-mode's native fontification.
;;   (doom-themes-org-config))

;; nerd icons
(use-package nerd-icons :ensure t)

;; modeline from doom emacs
(use-package
 doom-modeline
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
;;(use-package
;; auto-dim-other-buffers
;; :ensure t
;; :init
;; ;; Automatically dim other windows
;; (auto-dim-other-buffers-mode t))

;; Nyan cat position indicator
;; (use-package nyan-mode :ensure t :init (nyan-mode))

;; Better floating windows
(use-package popwin :ensure t :init (popwin-mode 1))


;; Sauron -- event handling
;; (use-package
;;  sauron
;;  :ensure t
;;  :init
;;  ;; note, you add (setq sauron-debug t) to get errors which can debug if
;;  ;; there's something wrong; normally, we catch such errors, since e.g an error
;;  ;; in one of the hooks may cause ERC to fail (i.e., the message won't come
;;  ;; trough).

;;  (global-set-key (kbd "C-c s") 'sauron-toggle-hide-show)
;;  (global-set-key (kbd "C-c t") 'sauron-clear)

;;  (setq sauron-modules '(sauron-dbus sauron-org sauron-notifications))

;;  (setq
;;   sauron-max-line-length 120

;;   ;; uncomment to show sauron in the current frame
;;   sauron-separate-frame nil

;;   ;; you probably want to add your own nickname to the these patterns
;;   sauron-watch-patterns
;;   '("emacs-fu"
;;     "emacsfu"
;;     "wombat"
;;     "capybara"
;;     "yak"
;;     "gnu"
;;     "\\bmu\\b"
;;     "mail")

;;   ;; you probably want to add you own nick here as well
;;   sauron-watch-nicks '("nikolay.nerovnyy" "locutus" "n.nerovny"))

;;  ;; some sound/light effects for certain events
;;  (add-hook
;;   'sauron-event-added-functions
;;   (lambda (origin prio msg &optional props)
;;     (if (string-match "ping" msg)
;;         (sauron-fx-sox "/usr/share/sounds/question.wav"))
;;     (cond
;;      ((= prio 3)
;;       (sauron-fx-sox "/usr/share/sounds/email.wav"))
;;      ((= prio 4)
;;       (sauron-fx-sox "/usr/share/sounds/email.wav"))
;;      ((= prio 5)
;;       (sauron-fx-sox "/usr/share/sounds/email.wav")
;;       (sauron-fx-gnome-osd (format "%S: %s" origin msg) 5)))))

;;  ;; events to ignore
;;  (add-hook
;;   'sauron-event-block-functions
;;   (lambda (origin prio msg &optional props)
;;     (or
;;      (string-match "^*** Users" msg)))) ;; filter out IRC spam

;;  (setq sauron-dbus-cookie t)
;;  (sauron-start))
