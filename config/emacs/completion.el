;; smex is a replacement for M-x
(use-package
  smex
  :ensure t
  :config (smex-initialize)
  ;;   (global-set-key (kbd "M-x") 'smex)
  ;; (global-set-key (kbd "M-X") 'smex-major-mode-commands)
  ;; ;; This is your old M-x.
  ;; (global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)
  )

;; Company mode
(use-package
  company
  :ensure t
  ;; Navigate in completion minibuffer with `C-n` and `C-p`.
  :bind (:map company-active-map
	      ("C-n" . company-select-next)
	      ("C-p" . company-select-previous))
  :config
  ;; Provide instant autocompletion.
  (setq company-idle-delay 0.3)

  ;; Use company mode everywhere.
  (global-company-mode t))

;; ivy completion
(use-package
  ivy
  :ensure t
  :init
  ;; Ivy completion setup
  (ivy-mode)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  ;; Do not put caret (^ symbol) at the beginning
  (setq ivy-initial-inputs-alist nil)
  ;; Ignore order in all completion
  ;; ex. format clang will also result in "clang-format"
  (setq ivy-re-builders-alist '((t . ivy--regex-ignore-order)))
  (setq ivy-enable-advanced-buffer-information t)
  (setq ivy-enable-icons t)
  (global-set-key "\C-s" 'swiper)
  (global-set-key (kbd "C-c C-r") 'ivy-resume)
  (global-set-key (kbd "<f6>") 'ivy-resume)
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file)
  (global-set-key (kbd "<f1> f") 'counsel-describe-function)
  (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
  (global-set-key (kbd "<f1> o") 'counsel-describe-symbol)
  (global-set-key (kbd "<f1> l") 'counsel-find-library)
  (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
  (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
  (global-set-key (kbd "C-c g") 'counsel-git)
  (global-set-key (kbd "C-c j") 'counsel-git-grep)
  (global-set-key (kbd "C-c k") 'counsel-ag)
  (global-set-key (kbd "C-x l") 'counsel-locate)
  (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
  (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history))

;; counsel-projectile
(use-package
  counsel-projectile
  :ensure t
  :after (projectile)
  :config
  ;; Use counsel for search through the project
  (global-set-key (kbd "C-S-s") 'counsel-projectile-grep))

(use-package
  all-the-icons-ivy-rich
  :ensure t
  :init (all-the-icons-ivy-rich-mode 1))

(use-package
  ivy-rich
  :ensure t
  :init (ivy-rich-mode 1))
