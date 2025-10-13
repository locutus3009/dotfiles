;; Better handling of paranthesis when writing Lisps.
;; (use-package
;;   paredit
;;   :ensure t
;;   :init (add-hook 'clojure-mode-hook #'enable-paredit-mode)
;;   (add-hook 'cider-repl-mode-hook #'enable-paredit-mode)
;;   (add-hook 'emacs-lisp-mode-hook #'enable-paredit-mode)
;;   (add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
;;   (add-hook 'ielm-mode-hook #'enable-paredit-mode)
;;   (add-hook 'lisp-mode-hook #'enable-paredit-mode)
;;   (add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
;;   (add-hook 'scheme-mode-hook #'enable-paredit-mode)
;;   :config (show-paren-mode t)
;;   :bind (("M-[" . paredit-wrap-square)
;; 	 ("M-{" . paredit-wrap-curly))
;;   :diminish nil)

;; Smart patenthesis
;; (use-package
;;   smartparens
;;   :ensure t
;;   :init (require 'smartparens-config)
;;   (smartparens-global-mode t)
;;   (show-smartparens-global-mode t)
;;   (setq sp-show-pair-from-inside t))

;; Enable mode that automatically inserts parenthesis
;; but that is much less annoying
(electric-pair-mode)

;; Multiple cursors
(use-package
 multiple-cursors
 :ensure t
 :config
 ;; Multiple cursors
 (global-set-key (kbd "C-M->") 'mc/mark-next-like-this)
 (global-set-key (kbd "C-M-<") 'mc/mark-previous-like-this)
 ;; (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
 )

;; iedit -- edit multiple similar places
(use-package iedit :ensure t :defer t)

;; vterm -- used by Projectile
(use-package vterm :ensure t :defer t)

(use-package
 markdown-mode
 :ensure t
 :commands (markdown-mode gfm-mode)
 :mode
 (("README\\.md\\'" . gfm-mode)
  ("\\.md\\'" . gfm-mode)
  ("\\.markdown\\'" . markdown-mode))
 :init
 (setq markdown-command "multimarkdown")
 (add-hook 'markdown-mode-hook 'auto-fill-mode)
 (add-hook 'markdown-mode-hook 'flyspell-mode))

(use-package
 move-text
 :ensure t
 :bind
 (:map global-map ("M-p" . move-text-up) ("M-n" . move-text-down)))

;; Beeter handling of system clipboard
;; (use-package simpleclip
;;   :ensure t
;;   :init
;;   (simpleclip-mode 1))

(use-package
 visual-fill-column
 :ensure t
 :defer t
 :config
 (add-hook
  'visual-line-mode-hook #'visual-fill-column-mode)
 (setq-default visual-fill-column-center-text t))

;; Goto last change
;; (use-package
;;  goto-last-change
;;  :ensure t)
