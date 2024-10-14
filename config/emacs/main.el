;;; my-main --- Main setup
;;; Commentary:
;;; none

;;; Code:

;; Disable startup message
(setq inhibit-startup-message t)
;; Disable toolbar
(tool-bar-mode -1)
;; Disable menu bar
(menu-bar-mode -1)
;; Disable scroll bar
(scroll-bar-mode -1)
;; Highlight current line
(global-hl-line-mode t)
;; Show line numbers
;; (line-number-mode t)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
;; (global-display-line-numbers-mode)

;; Auto open last edit place
(save-place-mode 1)

;; Follow the end of compilation output
(setq compilation-scroll-output t)

;; define function to shutdown emacs server instance
(defun server-shutdown ()
  "Save buffers, Quit, and Shutdown (kill) server"
  (interactive)
  (save-some-buffers)
  (kill-emacs))

;; Store authentification data in external file
(setq auth-sources '("~/.authinfo.gpg"))

;; Start as server
(require 'server)
(unless (server-running-p) (server-start))

(setq tramp-default-method "ssh")

;; Do not use `init.el` for `custom-*` code - use `custom-file.el`.
(setq custom-file "~/.emacs.d/custom.el")
(when (file-exists-p custom-file)
  (load custom-file))

;; Assuming that the code in custom-file is execute before the code
;; ahead of this line is not a safe assumption. So load this file
;; proactively.
;; (load-file custom-file)

;; Add melpa package manager
(require 'package)
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")
        ("marmalade" . "http://marmalade-repo.org/packages/")
        ("org" . "http://orgmode.org/elpa/") ; Org-mode's repository
        ("SC" . "http://joseito.republika.pl/sunrise-commander/")))
(package-initialize)
;; (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)

;; install use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
;; further reduce load time, from use-package official github page
(eval-when-compile
  (require 'use-package))

;; Use pinentry to type passwords
(use-package
 pinentry
 :ensure t
 :init
 (setq epg-pinentry-mode 'loopback)
 (pinentry-start))

(setq w3m-default-symbol
      '("─┼"
        " ├"
        "─┬"
        " ┌"
        "─┤"
        " │"
        "─┐"
        ""
        "─┴"
        " └"
        "──"
        ""
        "─┘"
        ""
        ""
        ""
        "─┼"
        " ┠"
        "━┯"
        " ┏"
        "─┨"
        " ┃"
        "━┓"
        ""
        "━┷"
        " ┗"
        "━━"
        ""
        "━┛"
        ""
        ""
        ""
        " •"
        " □"
        " ☆"
        " ○"
        " ■"
        " ★"
        " ◎"
        " ●"
        " △"
        " ●"
        " ○"
        " □"
        " ●"
        "≪ ↑ ↓ "))

(standard-display-ascii ?\227 " — ")

(setq visible-bell t)

;; backup in one place. flat, no tree structure
(setq backup-directory-alist '(("" . "~/.emacs.d/backup")))
