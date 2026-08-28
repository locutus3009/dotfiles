;;; dired.el --- Dired sidebar file browsing -*- lexical-binding: t; -*-
;;; Code:

(use-package dired-sidebar
  :ensure t
  :bind (("C-x C-n" . dired-sidebar-toggle-sidebar))
  :commands (dired-sidebar-toggle-sidebar)
  :config
  (setq dired-sidebar-subtree-line-prefix " .")
  (cond
   ((eq system-type 'darwin)
    (setq dired-sidebar-theme 'nerd-icons)
    (setq dired-sidebar-face '(:family "Hack Regular" :height 140)))
   ((eq system-type 'windows-nt)
    (setq dired-sidebar-theme 'nerd)
    (setq dired-sidebar-face '(:family "Droid Sans Mono" :height 110)))
   (t
    ;; 'nerd-icons drives nerd-icons-dired; plain 'nerd is the ASCII fallback.
    (setq dired-sidebar-theme 'nerd-icons)
    (setq dired-sidebar-face '(:family "Arial" :height 140))))

  (setq dired-sidebar-use-term-integration t)
  (setq dired-sidebar-use-custom-font t))

;; Replaces all-the-icons-dired -- nerd-icons is already in use by
;; doom-modeline, so there is no reason to carry a second icon set.
(use-package nerd-icons-dired
  :ensure t
  :after nerd-icons
  :commands (nerd-icons-dired-mode))

(provide 'dired)
;;; dired.el ends here
