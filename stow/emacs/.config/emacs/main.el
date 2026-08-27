;;; main.el --- Main setup -*- lexical-binding: t; -*-
;;; Commentary:
;;; Loaded first from init.el.  Frame geometry, GC and native-comp tuning are
;;; NOT here -- they have to run earlier, see ~/.emacs.d/early-init.el.
;;; Code:

;; Highlight current line
(global-hl-line-mode t)
;; Show line numbers in code buffers only
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; Auto open last edit place
(save-place-mode 1)

;; Follow the end of compilation output
(setq compilation-scroll-output t)

;; define function to shutdown emacs server instance
(defun server-shutdown ()
  "Save buffers, Quit, and Shutdown (kill) server."
  (interactive)
  (save-some-buffers)
  (kill-emacs))

;; Store authentification data in external file
(setq auth-sources '("~/.authinfo.gpg"))

;; Start as server
(require 'server)
(unless (server-running-p)
  (server-start))

(setq tramp-default-method "ssh")

;; Do not use `init.el' for `custom-*' code - use `custom-file.el'.
(setq custom-file "~/.emacs.d/custom.el")
(when (file-exists-p custom-file)
  (load custom-file))

;; Package archives.  `package-initialize' already ran from early-init.el
;; (Emacs 27+ does it automatically), so only the archive list is set here.
(require 'package)
(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))

;; use-package ships with Emacs since 29 -- no need to install it.
(require 'use-package)

;; Use pinentry to type passwords
(use-package pinentry
  :ensure t
  :init
  (setq epg-pinentry-mode 'loopback)
  (pinentry-start))

(setq visible-bell t)

;; backup in one place. flat, no tree structure
(setq backup-directory-alist '(("" . "~/.emacs.d/backup")))

(use-package exec-path-from-shell
  :ensure t
  :config
  (when (or (memq window-system '(mac ns x pgtk))
            (daemonp))
    (dolist (var '("PATH" "MANPATH" "SSH_AUTH_SOCK" "GPG_TTY"))
      (add-to-list 'exec-path-from-shell-variables var))
    (exec-path-from-shell-initialize)))

(provide 'main)
;;; main.el ends here
