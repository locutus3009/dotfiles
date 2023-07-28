;; Formatting of elisp
(use-package
  elisp-format
  :ensure t)

;; Flycheck -- syntax checking
(use-package
  flycheck
  :ensure t
  :init (global-flycheck-mode))

;; Language server
(use-package
  lsp-mode
  :ensure t
  ;; :after company
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  ;; (make-variable-buffer-local 'lsp-clients-clangd-args)
  (setq lsp-clients-clangd-args '("--compile-commands-dir=./build" "--query-driver=/**/bin/*"))
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (c++-mode . lsp-deferred)
	 (c-mode . lsp-deferred)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp
  :custom (lsp-auto-guess-root t)
  (lsp-prefer-capf t)
  (lsp-keep-workspace-alive nil))

;; Support of LUA programming language
(use-package lua-mode
  :ensure t)

;; optionally
(use-package
  lsp-ui
  :ensure t
  :commands lsp-ui-mode)

;; if you are ivy user
(use-package
  lsp-ivy
  :ensure t
  :after (ivy)
  :commands lsp-ivy-workspace-symbol)

;; ;; Extension of LSP for treemacs
;; (use-package
;;   lsp-treemacs
;;   :ensure t
;;   :commands lsp-treemacs-errors-list)

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
