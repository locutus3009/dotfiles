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
;; (add-hook 'prog-mode-hook 'display-line-numbers-mode)
(global-display-line-numbers-mode)

;; Auto open last edit place
(save-place-mode 1)

;; Do not use `init.el` for `custom-*` code - use `custom-file.el`.
(setq custom-file "~/.emacs.d/custom-file.el")

;; Assuming that the code in custom-file is execute before the code
;; ahead of this line is not a safe assumption. So load this file
;; proactively.
(load-file custom-file)

;; Add melpa package manager
(require 'package)
(package-initialize)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)

;; ;; Use spacemacs theme
;; (use-package
;;   spacemacs-theme
;;   :config
;;   ;; Do not use a different background color for comments.
;;   (setq spacemacs-theme-comment-bg nil)

;;   ;; Comments should appear in italics.
;;   (setq spacemacs-theme-comment-italic t)

;;   ;; Use the `spacemacs-dark` theme.
;;   (load-theme 'spacemacs-dark))

;; Solarized theme
;; (use-package
;;   solarized-theme
;;   :ensure t
;;   :config
;;   (load-theme 'solarized-dark t))

;; Doom emacs themes
(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-oceanic-next t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  ;; (doom-themes-neotree-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

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

;; Git integration for Emacs
(use-package
  magit
  :ensure t
  :bind ("C-x g" . magit-status))

;; Better handling of paranthesis when writing Lisps.
(use-package
  paredit
  :ensure t
  :init (add-hook 'clojure-mode-hook #'enable-paredit-mode)
  (add-hook 'cider-repl-mode-hook #'enable-paredit-mode)
  (add-hook 'emacs-lisp-mode-hook #'enable-paredit-mode)
  (add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
  (add-hook 'ielm-mode-hook #'enable-paredit-mode)
  (add-hook 'lisp-mode-hook #'enable-paredit-mode)
  (add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
  (add-hook 'scheme-mode-hook #'enable-paredit-mode)
  :config (show-paren-mode t)
  :bind (("M-[" . paredit-wrap-square)
	 ("M-{" . paredit-wrap-curly))
  :diminish nil)

;; Smart patenthesis
(use-package
  smartparens
  :ensure t
  :init (require 'smartparens-config)
  (smartparens-global-mode t)
  (show-smartparens-global-mode t)
  (setq sp-show-pair-from-inside t))

;; Auto dim other window
(use-package
  auto-dim-other-buffers
  :ensure t
  :init
  ;; Automatically dim other windows
  (auto-dim-other-buffers-mode t))

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

(use-package
  projectile
  :ensure t
  :config (projectile-mode +1)
  ;; Recommended keymap prefix on Windows/Linux
  (define-key projectile-mode-map (kbd "M-m p") 'projectile-command-map)
  (setq projectile-project-search-path '("~/dev" ("~/dev/hm-grc-scripts" . 2))))

;; counsel-projectile
(use-package
  counsel-projectile
  :ensure t
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

;; Formatting of elisp
(use-package
  elisp-format
  :ensure t)

(use-package
  org
  :ensure t
  :config
  ;; (org :variables
  ;;      org-enable-jira-support t
  ;;      org-jira-working-dir "~/org/")

  ;; Sequences of keywords used in org-mode
  (setq org-todo-keywords (quote ((sequence "TODO(t)" "NEXT(n)" "IN_REVIEW(r)" "|" "DONE(d)")
				  (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)"
					    "PHONE" "MEETING"))))

  ;; Set colors for org-mode keywords
  (setq org-todo-keyword-faces (quote (("TODO" :foreground "red"
					:weight bold)
				       ("NEXT" :foreground "blue"
					:weight bold)
				       ("DONE" :foreground "green "
					:weight bold)
				       ("WAITING" :foreground "orange"
					:weight bold)
				       ("HOLD" :foreground "magenta"
					:weight bold)
				       ("CANCELLED" :foreground "yellow"
					:weight bold)
				       ("MEETING" :foreground "yellow"
					:weight bold)
				       ("PHONE" :foreground "yellow"
					:weight bold)
				       ("IN_REVIEW" :foreground "orange"
					:weight bold))))

  ;; Set follow rules
  (setq org-todo-state-tags-triggers (quote (("CANCELLED" ("CANCELLED" . t))
					     ("WAITING" ("WAITING" . t))
					     ("HOLD" ("WAITING")
					      ("HOLD" . t))
					     (done ("WAITING")
						   ("HOLD"))
					     ("TODO" ("WAITING")
					      ("CANCELLED")
					      ("HOLD"))
					     ("NEXT" ("WAITING")
					      ("CANCELLED")
					      ("HOLD"))
					     ("DONE" ("WAITING")
					      ("CANCELLED")
					      ("HOLD")))))

  ;; Follow mode
  (add-hook 'org-agenda-mode-hook #'org-agenda-follow-mode)

  ;; Define the custum capture templates
  (setq org-capture-templates '(("t" "todo" entry (file org-default-notes-file)
				 "* TODO %?\n%u\n%a\n"
				 :clock-in t
				 :clock-resume t)
				("m" "Meeting" entry (file org-default-notes-file)
				 "* MEETING with %? :MEETING:\n%t\n%a\n"
				 :clock-in t
				 :clock-resume t)
				("j" "Journal" entry (file+datetree "~/org/journal.org")
				 "* %? :JOURNAL:\n%t\n%U\n%i\n%a\n"
				 :clock-in t
				 :clock-resume t)
				("i" "Idea" entry (file org-default-notes-file)
				 "* %? :IDEA:\n%t\n%a\n"
				 :clock-in t
				 :clock-resume t)
				("n" "Next Task" entry (file+headline org-default-notes-file
								      "Tasks")
				 "** NEXT %? \nDEADLINE: %t") ))
  (setq org-refile-targets (quote ((nil :maxlevel . 9)
				   (org-agenda-files :maxlevel . 9))))
  (setq org-agenda-start-on-weekday 1)
  (setq calendar-week-start-day 1)
  (require 'epa-file)
  (epa-file-enable)
  (require 'org-tempo)
  (setq org-agenda-files (append (file-expand-wildcards "~/org/*.org"))))

(use-package
  mu4e
  :ensure t
  :config
  ;; (mu4e :variables
  ;;       mu4e-use-maildirs-extension t
  ;;       mu4e-enable-async-operations nil
  ;;       mu4e-enable-notifications t
  ;;       mu4e-enable-mode-line t)

  ;; SMTP settings:
  (setq send-mail-function 'smtpmail-send-it) ; should not be modified
  (setq smtpmail-smtp-server "pop.huawei.com") ; host running SMTP server
  (setq smtpmail-smtp-service 25)    ; SMTP service port number
  (setq smtpmail-stream-type 'plain) ; type of SMTP connections to use
  (setq smtpmail-smtp-user "n00834167")
                                        ;(setq smtpmail-auth-credentials (expand-file-name "~/.authinfo.gpg"))
  (setq user-mail-address "nikolay.nerovnyy@huawei.com")

  ;; Mail folders:
  (setq mu4e-drafts-folder "/Drafts")
  (setq mu4e-sent-folder   "/Sent Items")
  (setq mu4e-trash-folder  "/Trash")

  ;; The command used to get your emails (adapt this line, see section 2.3):
  (setq mu4e-get-mail-command "mbsync --config ~/.config/.mbsyncrc work")
  ;; Further customization:
  (setq mu4e-html2text-command "w3m -T text/html" ; how to hanfle html-formatted emails
	mu4e-update-interval 300 ; seconds between each mail retrieval
	mu4e-headers-auto-update t    ; avoid to type `g' to update
	mu4e-view-show-images t	      ; show images in the view buffer
	mu4e-compose-signature-auto-include nil ; I don't want a message signature
	mu4e-use-fancy-chars t)	  ; allow fancy icons for mail threads
  )

(load-file "~/.emacs/keys.el")
(load-file "~/.emacs/projects/lotto.el")
(load-file "~/.emacs/projects/hm-uvmm.el")
(load-file "~/.emacs/projects/hm-verif-kernel.el")
(load-file "~/.emacs/projects/hm-grc-scripts.el")

;; (use-package
;;   gitlab
;; :ensure t
;; :config
;; ;; GitLab
;; (setq gitlab-host "https://rnd-gitlab-eu-c.huawei.com" gitlab-token-id "nvKAC85y-nujqM6F8-Gy")
;; )

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

;; Spacemacs-like dashboard
(use-package
  dashboard
  :ensure t
  :config (dashboard-setup-startup-hook)
  (setq initial-buffer-choice (lambda ()
				(get-buffer-create "*dashboard*")))
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

(use-package
  treemacs
  :ensure t
  :defer t
  :init (with-eval-after-load 'winum (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config (progn
	    (setq treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
		  treemacs-deferred-git-apply-delay        0.5 treemacs-directory-name-transformer
		  #'identity treemacs-display-in-side-window          t treemacs-eldoc-display
		  'simple treemacs-file-event-delay                2000
		  treemacs-file-extension-regex            treemacs-last-period-regex-value
		  treemacs-file-follow-delay               0.2 treemacs-file-name-transformer
		  #'identity treemacs-follow-after-init               t treemacs-expand-after-init t
		  treemacs-find-workspace-method           'find-for-file-or-pick-first
		  treemacs-git-command-pipe                "" treemacs-goto-tag-strategy
		  'refetch-index treemacs-header-scroll-indicators        '(nil . "^^^^^^")
		  treemacs-hide-dot-git-directory          t treemacs-indentation 2
		  treemacs-indentation-string              " " treemacs-is-never-other-window nil
		  treemacs-max-git-entries                 5000 treemacs-missing-project-action 'ask
		  treemacs-move-forward-on-expand          nil treemacs-no-png-images nil
		  treemacs-no-delete-other-windows         t treemacs-project-follow-cleanup nil
		  treemacs-persist-file                    (expand-file-name
							    ".cache/treemacs-persist"
							    user-emacs-directory) treemacs-position
							    'left treemacs-read-string-input
							    'from-child-frame
							    treemacs-recenter-distance 0.1
							    treemacs-recenter-after-file-follow nil
							    treemacs-recenter-after-tag-follow nil
							    treemacs-recenter-after-project-jump
							    'always
							    treemacs-recenter-after-project-expand
							    'on-distance treemacs-litter-directories
							    '("/node_modules" "/.venv" "/.cask")
							    treemacs-project-follow-into-home nil
							    treemacs-show-cursor nil
							    treemacs-show-hidden-files t
							    treemacs-silent-filewatch nil
							    treemacs-silent-refresh nil
							    treemacs-sorting 'alphabetic-asc
							    treemacs-select-when-already-in-treemacs
							    'move-back
							    treemacs-space-between-root-nodes t
							    treemacs-tag-follow-cleanup t
							    treemacs-tag-follow-delay 1.5
							    treemacs-text-scale nil
							    treemacs-user-mode-line-format nil
							    treemacs-user-header-line-format nil
							    treemacs-wide-toggle-width 70
							    treemacs-width 35
							    treemacs-width-increment 1
							    treemacs-width-is-initially-locked t
							    treemacs-workspace-switch-cleanup nil)

	    ;; The default width and height of the icons is 22 pixels. If you are
	    ;; using a Hi-DPI display, uncomment this to double the icon size.
	    ;;(treemacs-resize-icons 44)
	    (treemacs-follow-mode t)
	    (treemacs-filewatch-mode t)
	    (treemacs-fringe-indicator-mode 'always)
	    (when treemacs-python-executable (treemacs-git-commit-diff-mode t))
	    (pcase (cons (not (null (executable-find "git")))
			 (not (null treemacs-python-executable)))
	      (`(t . t)
	       (treemacs-git-mode 'deferred))
	      (`(t . _)
	       (treemacs-git-mode 'simple)))
	    (treemacs-hide-gitignored-files-mode nil))
  :bind (:map global-map
	      ("M-0"       . treemacs-select-window)
	      ("C-x t 1"   . treemacs-delete-other-windows)
	      ("C-x t t"   . treemacs)
	      ("C-x t d"   . treemacs-select-directory)
	      ("C-x t B"   . treemacs-bookmark)
	      ("C-x t C-t" . treemacs-find-file)
	      ("C-x t M-t" . treemacs-find-tag)))

(use-package
  treemacs-evil
  :after (treemacs evil)
  :ensure t)

(use-package
  treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package
  treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  :ensure t)

(use-package
  treemacs-magit
  :after (treemacs magit)
  :ensure t)

(use-package
  treemacs-persp ;;treemacs-perspective if you use perspective.el vs. persp-mode
  :after (treemacs persp-mode) ;;or perspective vs. persp-mode
  :ensure t
  :config (treemacs-set-scope-type 'Perspectives))

(use-package
  treemacs-tab-bar ;;treemacs-tab-bar if you use tab-bar-mode
  :after (treemacs)
  :ensure t
  :config (treemacs-set-scope-type 'Tabs))

;; Flycheck -- syntax checking
(use-package
  flycheck
  :ensure t
  :init (global-flycheck-mode))

;; Language server
(use-package
  lsp-mode
  :ensure t
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (c++-mode . lsp)
	 (c-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp
  :custom (lsp-auto-guess-root t)
  (lsp-prefer-capf t)
  (lsp-keep-workspace-alive nil))

;; optionally
(use-package
  lsp-ui
  :ensure t
  :commands lsp-ui-mode)

;; if you are ivy user
(use-package
  lsp-ivy
  :ensure t
  :commands lsp-ivy-workspace-symbol)

;; Extension of LSP for treemacs
(use-package
  lsp-treemacs
  :ensure t
  :commands lsp-treemacs-errors-list)

;; optional if you want which-key integration
(use-package
  which-key
  :ensure t
  :config (which-key-mode))

;; clang-format
(use-package
  clang-format
  :after (s)
  :init (defun get-clang-format-option (config-str field is-num)
	  "Retrieve a config option from a clang-format config.

CONFIG-STR is a string containing the entire clang-format config.
FIELD is specific option, e.g. `IndentWidth'.  IS-NUM is a
boolean that should be set to 1 if the option is numeric,
otherwise assumed alphabetic."
	  (if is-num (let ((primary-match (s-match (concat "^" field ":[ \t]*[0-9]+") config-str)))
		       (if primary-match (string-to-number (car (s-match "[0-9]+" (car
										   primary-match))))
			 0))
	    (let ((primary-match (s-match (concat "^" field ":[ \t]*[A-Za-z]+") config-str)))
	      (if primary-match (car (s-match "[A-Za-z]+$" (car primary-match))) ""))))
  :hook (c-mode-common . (lambda ()
			   (let* ((clang-format-config (shell-command-to-string
							"clang-format -dump-config"))
				  (c-offset (get-clang-format-option clang-format-config
								     "IndentWidth" t))
				  (tabs-str (get-clang-format-option clang-format-config "UseTab"
								     nil))
				  (base-style (get-clang-format-option clang-format-config
								       "BasedOnStyle" nil)))
			     (progn (if (> c-offset 0)
					(setq-local c-basic-offset c-offset)
				      (if (not (equal "" base-style))
					  (cond ((or
						  (equal "LLVM" base-style)
						  (equal "Google" base-style)
						  (equal "Chromium" base-style)
						  (equal "Mozilla" base-style))
						 (setq-local c-basic-offset 2))
						((equal "WebKit" base-style)
						 (setq-local c-basic-offset 4)))))
				    (if (not (equal "" tabs-str))
					(if (not (string-equal "Never" tabs-str))
					    (setq-local indent-tabs-mode t)
					  (setq-local indent-tabs-mode nil))
				      (if (not (equal "" base-style))
					  (cond ((or
						  (equal "LLVM" base-style)
						  (equal "Google" base-style)
						  (equal "Chromium" base-style)
						  (equal "Mozilla" base-style)
						  (equal "WebKit" base-style))
						 (setq-local indent-tabs-mode nil))))))))))

;; nerd icons
(use-package nerd-icons
  :ensure t)

;; modeline from doom emacs
(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode)
  :config
  (setq doom-modeline-project-detection 'projectile)
  (setq find-file-visit-truename t))

;; ;; A nice looking modeline enhancement
;; (use-package spaceline
;;   :ensure t)

;; ;; Add some visual flair to the modeline enhancements
;; (use-package spaceline-all-the-icons
;;   :ensure t
;;   :after spaceline
;;   :config (spaceline-all-the-icons-theme)
;;   (spaceline-all-the-icons--setup-neotree)
;;   (spaceline-emacs-theme))

;; (use-package
;;   smart-mode-line
;;   :ensure t
;;   :init
;;   (sml/setup))
