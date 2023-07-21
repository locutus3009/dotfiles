(load-file "~/.emacs/common/agenda.el")
(load-file "~/.emacs/common/mail.el")
(load-file "~/.emacs/common/keys.el")
(load-file "~/.emacs/common/projects/lotto.el")
(load-file "~/.emacs/common/projects/hm-uvmm.el")
(load-file "~/.emacs/common/projects/hm-verif-kernel.el")
(load-file "~/.emacs/common/projects/hm-grc-scripts.el")

;; Multiple cursors
(global-set-key (kbd "C-M->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-M-<") 'mc/mark-previous-like-this)
;; (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; Use counsel for search through the project
(global-set-key (kbd "C-S-s") 'counsel-projectile-grep)

;; (setq epa-pinentry-mode 'loopback)

;; Fine tune smartparens package
(require 'smartparens-config)
(smartparens-global-mode t)
(show-smartparens-global-mode t)
(setq sp-show-pair-from-inside t)

;; GitLab
(setq gitlab-host "https://rnd-gitlab-eu-c.huawei.com" gitlab-token-id "nvKAC85y-nujqM6F8-Gy")

;; Follow the end of compilation output
(setq compilation-scroll-output t)

;; Tune projectile to compile & run interactively
(defun my/projectile-run (arg &optional dir)
  "Run a projectile project passing t to `compile'
because by default projectile does not."
  (interactive "P")
  (when (projectile-project-p)
    (let* ((project-root (projectile-project-root))
           (default-run-cmd (projectile-run-command project-root))
           (run-cmd (projectile-maybe-read-command arg default-run-cmd "Run command: "))
           (default-directory project-root))
      (puthash project-root run-cmd projectile-run-cmd-map)
      ;; Pass a lambda to projectile-run-compilation so that we can add
      ;; the `t' parameter to `compilation-start', which runs the
      ;; compilation buffer under `comint-mode' mode, so it can read
      ;; keyboard input.
      (projectile-run-compilation (lambda ()
                                    (compile run-cmd t))))))

;; Make compile-command file- and directory-local
(make-variable-buffer-local 'compile-command)

;; Automatically dim other windows
(auto-dim-other-buffers-mode t)

;; Ivy completion setup
;; Do not put caret (^ symbol) at the beginning
(setq ivy-initial-inputs-alist nil)
;; Ignore order in all completion
;; ex. format clang will also result in "clang-format"
(setq ivy-re-builders-alist '((t . ivy--regex-ignore-order)))
