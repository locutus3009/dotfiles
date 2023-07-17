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
(line-number-mode t)

;; Disable easy navigation keys
(global-unset-key (kbd "<left>"))
(global-unset-key (kbd "<right>"))
(global-unset-key (kbd "<up>"))
(global-unset-key (kbd "<down>"))
(global-unset-key (kbd "<C-left>"))
(global-unset-key (kbd "<C-right>"))
(global-unset-key (kbd "<C-up>"))
(global-unset-key (kbd "<C-down>"))
(global-unset-key (kbd "<M-left>"))
(global-unset-key (kbd "<M-right>"))
(global-unset-key (kbd "<M-up>"))
(global-unset-key (kbd "<M-down>"))
(global-unset-key (kbd "<prior>"))
(global-unset-key (kbd "<next>"))
(global-unset-key (kbd "<deletechar>"))
(global-unset-key (kbd "<C-delete>"))
(global-unset-key (kbd "<home>"))
(global-unset-key (kbd "<end>"))

(global-set-key (kbd "TAB") `tab-to-tab-stop)

;; Do not use `init.el` for `custom-*` code - use `custom-file.el`.
(setq custom-file ".emacs/my/custom-file.el")

;; Assuming that the code in custom-file is execute before the code
;; ahead of this line is not a safe assumption. So load this file
;; proactively.
(load-file custom-file)

;; Add melpa package manager
(require 'package)
(package-initialize)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

(use-package spacemacs-theme
  :config
  ;; Do not use a different background color for comments.
  (setq spacemacs-theme-comment-bg nil)

  ;; Comments should appear in italics.
  (setq spacemacs-theme-comment-italic t)

  ;; Use the `spacemacs-dark` theme.
  (load-theme 'spacemacs-dark))


(use-package company
  ;; Navigate in completion minibuffer with `C-n` and `C-p`.
  :bind (:map company-active-map
         ("C-n" . company-select-next)
         ("C-p" . company-select-previous))
  :config
  ;; Provide instant autocompletion.
  (setq company-idle-delay 0.3)

  ;; Use company mode everywhere.
  (global-company-mode t))

;; Git integration for Emacs
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

;; Better handling of paranthesis when writing Lisps.
(use-package paredit
  :ensure t
  :init
  (add-hook 'clojure-mode-hook #'enable-paredit-mode)
  (add-hook 'cider-repl-mode-hook #'enable-paredit-mode)
  (add-hook 'emacs-lisp-mode-hook #'enable-paredit-mode)
  (add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
  (add-hook 'ielm-mode-hook #'enable-paredit-mode)
  (add-hook 'lisp-mode-hook #'enable-paredit-mode)
  (add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
  (add-hook 'scheme-mode-hook #'enable-paredit-mode)
  :config
  (show-paren-mode t)
  :bind (("M-[" . paredit-wrap-square)
         ("M-{" . paredit-wrap-curly))
  :diminish nil)

;; Smart patenthesis
(use-package smartparens
  :ensure t
  :init
  (require 'smartparens-config))

;; helm core
(use-package helm
  :ensure t)
