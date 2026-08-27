;;; completion.el --- Substitution, completion, selection and suggestions -*- lexical-binding: t; -*-
;;; Code:

;; Company mode
;; `:demand t' is load-bearing: `:bind' implies `:defer', which used to push
;; `:config' -- and with it `global-company-mode' -- into an eval-after-load
;; that only fired if something else happened to pull company in.
(use-package company
  :ensure t
  :demand t
  ;; Navigate in completion minibuffer with `C-n' and `C-p'.
  :bind
  (:map company-active-map
        ("C-n" . company-select-next)
        ("C-p" . company-select-previous)
        ("M-/" . company-complete-common-or-cycle))
  :config
  ;; Provide instant autocompletion.
  (setq company-idle-delay 0.3)
  ;; Use company mode everywhere.
  (global-company-mode t))

;; Completion for shell
(use-package company-shell
  :ensure t
  :defer t
  :config
  (add-to-list 'company-backends
               '(company-shell company-shell-env company-fish-shell)))

;; ivy completion
(use-package ivy
  :ensure t
  :init
  (ivy-mode)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  ;; Do not put caret (^ symbol) at the beginning
  (setq ivy-initial-inputs-alist nil)
  ;; Ignore order in all completion
  ;; ex. format clang will also result in "clang-format"
  (setq ivy-re-builders-alist '((t . ivy--regex-ignore-order)))
  (setq ivy-enable-advanced-buffer-information t)
  (setq ivy-count-format "(%d/%d) ")
  :bind
  (("C-c C-r" . ivy-resume)
   ("<f6>" . ivy-resume)))

;; swiper and counsel are separate packages from ivy -- declared here so a
;; fresh checkout installs them, instead of relying on them arriving as some
;; other package's dependency.
(use-package swiper
  :ensure t
  :bind ("C-s" . swiper))

;; Recency/frequency ranking for `counsel-M-x' -- this is what smex provided,
;; and dropping smex silently dropped the ranking with it.  counsel picks amx
;; over smex on its own (see `counsel-M-x-source'); amx is the maintained fork,
;; smex stopped in 2015.  Deferred: counsel `require's it on the first M-x.
;; Ranking history was migrated from ~/.emacs.d/smex-items to ~/.emacs.d/amx-items.
(use-package amx :ensure t :defer t)

(defun my/counsel-projectile-rg ()
  "Run `counsel-rg' in the current project root."
  (interactive)
  (let ((default-directory (projectile-project-root)))
    (counsel-rg)))

(use-package counsel
  :ensure t
  :bind
  (("M-x" . counsel-M-x)
   ("C-x C-f" . counsel-find-file)
   ("C-x l" . counsel-locate)
   ;; C-c g is magit-file-dispatch, see projects.el
   ("C-c G" . counsel-git)
   ("C-c j" . counsel-git-grep)
   ("C-c k" . counsel-rg)
   ("C-S-s" . my/counsel-projectile-rg)
   ("<f1> f" . counsel-describe-function)
   ("<f1> v" . counsel-describe-variable)
   ("<f1> o" . counsel-describe-symbol)
   ("<f1> l" . counsel-find-library)
   ("<f2> i" . counsel-info-lookup-symbol)
   ("<f2> u" . counsel-unicode-char)
   :map minibuffer-local-map
   ("C-r" . counsel-minibuffer-history)))

;; NB: do NOT hang these off counsel -- counsel is deferred until its first
;; key press, so `:after counsel' would leave ivy-rich switched off.
(use-package ivy-rich
  :ensure t
  :after ivy
  :init (ivy-rich-mode 1))

(use-package nerd-icons-ivy-rich
  :ensure t
  :after ivy-rich
  :init (nerd-icons-ivy-rich-mode 1))

(provide 'completion)
;;; completion.el ends here
