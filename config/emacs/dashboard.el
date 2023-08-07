;; Spacemacs-like dashboard
(use-package
  dashboard
  :ensure t
  :after (projectile counsel all-the-icons)
  :config (dashboard-setup-startup-hook)
  (setq initial-buffer-choice (lambda ()
				(dashboard-refresh-buffer)(get-buffer-create "*dashboard*")))
  (setq dashboard-items '((recents  . 10)
			  (projects . 5)
			  (agenda . 10)
			  (bookmarks . 5)))
  (setq dashboard-set-heading-icons t)
  (setq dashboard-icon-type 'all-the-icons)
  (setq dashboard-heading-icons '((recents   . "history")
				  (bookmarks . "bookmark")
				  (agenda    . "calendar")
				  (projects  . "rocket")
				  (registers . "database")))
  (setq dashboard-set-navigator t)
  (setq dashboard-set-init-info t)
  (setq dashboard-projects-switch-function 'counsel-projectile-switch-project-by-name)
  (setq dashboard-projects-backend 'projectile))

;; (dashboard-refresh-buffer)
