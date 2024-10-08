(use-package
 dired-sidebar
 :bind (("C-x C-n" . dired-sidebar-toggle-sidebar))
 :ensure t
 :commands (dired-sidebar-toggle-sidebar)
 :config
 (setq dired-sidebar-subtree-line-prefix " .")
 (cond
  ((eq system-type 'darwin)
   (if (display-graphic-p)
       (setq dired-sidebar-theme 'icons)
     (setq dired-sidebar-theme 'nerd))
   (setq dired-sidebar-face '(:family "Hack Regular" :height 140)))
  ((eq system-type 'windows-nt)
   (setq dired-sidebar-theme 'nerd)
   (setq dired-sidebar-face '(:family "Droid Sans Mono" :height 110)))
  (:default
   (setq dired-sidebar-theme 'nerd)
   (setq dired-sidebar-face '(:family "Arial" :height 140))))

 (setq dired-sidebar-use-term-integration t)
 (setq dired-sidebar-use-custom-font t)

 (use-package
  all-the-icons-dired
  ;; M-x all-the-icons-install-fonts
  :ensure t
  :commands (all-the-icons-dired-mode)))
