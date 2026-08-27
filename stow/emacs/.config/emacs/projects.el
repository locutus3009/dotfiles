;;; projects.el --- Projects and source control -*- lexical-binding: t; -*-
;;; Code:

;; Git integration for Emacs
(use-package magit
  :ensure t
  :bind
  (("C-x g" . magit-status)
   ("C-c g" . magit-file-dispatch))
  :config
  ;; For Magit: disable auto revert buffer.  This has to actually turn the
  ;; mode off -- setting the variable to nil does nothing, the mode is already
  ;; on by the time :config runs.
  (magit-auto-revert-mode -1)
  (setq magit-gpg-secret-key-hist nil)) ; For working gpg-agent

;; SQlite3 is needed by forge
(use-package sqlite3 :ensure t :defer t)

;; Magit-forge allows to connect to gitlab
(use-package forge
  :ensure t
  :after magit sqlite3
  :config
  (add-to-list 'forge-alist
               '("rnd-gitlab-eu-c.huawei.com"
                 "rnd-gitlab-eu-c.huawei.com/api/v4"
                 "rnd-gitlab-eu-c.huawei.com"
                 forge-gitlab-repository))
  (add-to-list 'forge-owned-accounts '(("n00834167"))))

(use-package projectile
  :ensure t
  :config
  (projectile-mode +1)
  ;; Recommended keymap prefix on Windows/Linux
  (define-key projectile-mode-map (kbd "C-c C-p") 'projectile-command-map)
  (setq projectile-completion-system 'ivy
        projectile-enable-caching t
        projectile-indexing-method 'alien)
  (setq projectile-run-use-comint-mode t)
  (setq projectile-compile-use-comint-mode t)
  (setq projectile-project-search-path
        '("~/dev" ("~/dev/hm-grc-scripts" . 2)))
  ;; Use ggtags explicitly
  (setq projectile-tags-backend 'ggtags))

;; Tune projectile to compile & run interactively
(defun my/projectile-run (arg &optional dir)
  "Run a projectile project passing t to `compile'
because by default projectile does not."
  (interactive "P")
  (when (projectile-project-p)
    (let* ((project-root (projectile-project-root))
           (default-run-cmd (projectile-run-command project-root))
           (run-cmd
            (projectile-maybe-read-command
             arg default-run-cmd "Run command: "))
           (default-directory project-root))
      (puthash project-root run-cmd projectile-run-cmd-map)
      ;; Pass a lambda to projectile-run-compilation so that we can add
      ;; the `t' parameter to `compilation-start', which runs the
      ;; compilation buffer under `comint-mode' mode, so it can read
      ;; keyboard input.
      (projectile-run-compilation (lambda () (compile run-cmd t))))))

;; Make compile-command file- and directory-local
(make-variable-buffer-local 'compile-command)

;; Projects
(load-file "~/.config/emacs/projects/linux.el")
(load-file "~/.config/emacs/projects/dummy.el")
(load-file "~/.config/emacs/projects/gpu-verification.el")

(provide 'projects)
;;; projects.el ends here
