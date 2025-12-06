;; Formatting of elisp
;; (use-package
;;   elisp-format
;;   :ensure t)

(use-package
 elisp-autofmt
 :ensure t
 :defer t
 :config
 (setq elisp-autofmt-python-bin "python3")
 (setq elisp-autofmt-style 'native)
 (elisp-autofmt-mode t))

;; Flycheck -- syntax checking
(use-package
 flycheck
 :ensure t
 :init
 (global-flycheck-mode)
 (setq flycheck-rust-cargo-executable "~/.cargo/bin/cargo"))

(use-package
 highlight-parentheses
 :ensure t
 :hook ((prog-mode . highlight-parentheses-mode)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Rustic
;; https://robert.kra.hn/posts/rust-emacs-setup/#rustic
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package
 rustic
 :ensure
 :bind
 (:map
  rustic-mode-map
  ("M-j" . lsp-ui-imenu)
  ("M-?" . lsp-find-references)
  ("C-c C-c l" . flycheck-list-errors)
  ("C-c C-c a" . lsp-execute-code-action)
  ("C-c C-c r" . lsp-rename)
  ("C-c C-c q" . lsp-workspace-restart)
  ("C-c C-c Q" . lsp-workspace-shutdown)
  ("C-c C-c s" . lsp-rust-analyzer-status))
 :config
 ;; uncomment for less flashiness
 ;; (setq lsp-eldoc-hook nil)
 ;; (setq lsp-enable-symbol-highlighting nil)
 ;; (setq lsp-signature-auto-activate nil)

 ;; comment to disable rustfmt on save
 (setq rustic-format-on-save t)
 (add-hook 'rustic-mode-hook 'rk/rustic-mode-hook))

(defun rk/rustic-mode-hook ()
  ;; so that run C-c C-c C-r works without having to confirm, but don't try to
  ;; save rust buffers that are not file visiting. Once
  ;; https://github.com/brotzeit/rustic/issues/253 has been resolved this should
  ;; no longer be necessary.
  (when buffer-file-name
    (setq-local buffer-save-without-query t))
  (add-hook 'before-save-hook 'lsp-format-buffer nil t))

(use-package dash :ensure t :defer t :config (require 'dash))

(use-package
 irony
 :ensure t
 :disabled
 :config
 (progn
   ;; If irony server was never installed, install it.
   (unless (irony--find-server-executable)
     (call-interactively #'irony-install-server))

   (add-hook 'c++-mode-hook 'irony-mode)
   (add-hook 'c-mode-hook 'irony-mode)

   ;; Use compilation database first, clang_complete as fallback.
   (setq-default irony-cdb-compilation-databases
                 '(irony-cdb-libclang irony-cdb-clang-complete))

   (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)))

;; I use irony with flycheck to get real-time syntax checking.
(use-package
 flycheck-irony
 :ensure t
 :requires (flycheck irony)
 :config
 (progn
   (eval-after-load
       'flycheck
     '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))))

;; Eldoc shows argument list of the function you are currently writing in the echo area.
(use-package
 irony-eldoc
 :ensure t
 :requires (eldoc irony)
 :config
 (progn
   (add-hook 'irony-mode-hook #'irony-eldoc)))

;; Language server
(use-package
 lsp-mode
 :ensure t
 ;; :after company
 :init
 ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
 (setq lsp-keymap-prefix "C-c l")
 ;; (make-variable-buffer-local 'lsp-clients-clangd-args)
 (setq lsp-clients-clangd-args
       '("--compile-commands-dir=./build" "--query-driver=/**/bin/*"))
 :hook
 ( ;; replace XXX-mode with concrete major-mode(e. g. python-mode)
  (c++-mode . lsp-deferred)
  (c-mode . lsp-deferred)
  ;; if you want which-key integration
  (lsp-mode . lsp-enable-which-key-integration))
 :commands lsp
 :config (add-hook 'lsp-mode-hook 'lsp-ui-mode)
 :custom
 ;; what to use when checking on-save. "check" is default, I prefer clippy
 (lsp-rust-analyzer-cargo-watch-command "clippy")
 (lsp-eldoc-render-all t)
 (lsp-idle-delay 0.6)
 ;; enable / disable the hints as you prefer:
 (lsp-rust-analyzer-server-display-inlay-hints t)
 (lsp-rust-analyzer-display-lifetime-elision-hints-enable
  "skip_trivial")
 (lsp-rust-analyzer-display-chaining-hints t)
 (lsp-rust-analyzer-display-lifetime-elision-hints-use-parameter-names
  nil)
 (lsp-rust-analyzer-display-closure-return-type-hints t)
 (lsp-rust-analyzer-display-parameter-hints nil)
 (lsp-rust-analyzer-display-reborrow-hints nil)

 (lsp-auto-guess-root t)
 (lsp-prefer-capf t)
 (lsp-keep-workspace-alive nil)

 ;; Performance improvements
 (lsp-completion-provider :none) ; Use company instead
 (lsp-headerline-breadcrumb-enable nil)
 (lsp-enable-file-watchers nil) ; Big performance gain
 (lsp-enable-folding nil)
 (lsp-enable-snippet nil)
 (lsp-log-io nil))

;; Support of LUA programming language
(use-package lua-mode :ensure t :defer t)

(defun format-lua-buffer ()
  "Format the current buffer using luaformatter."
  (interactive)
  (let* ((tmpfile (make-temp-file "luaformat"))
         (command (format "lua-format -i %s" tmpfile)))
    (unwind-protect
        (progn
          (write-region nil nil tmpfile)
          (shell-command command nil)
          (delete-region (point-min) (point-max))
          (insert-file-contents tmpfile))
      (delete-file tmpfile))))

;; optionally
(use-package
 lsp-ui
 :ensure t
 :commands lsp-ui-mode
 :config
 (define-key
  lsp-ui-mode-map
  [remap xref-find-definitions]
  #'lsp-ui-peek-find-definitions)
 (define-key
  lsp-ui-mode-map
  [remap xref-find-references]
  #'lsp-ui-peek-find-references)
 :custom
 (lsp-ui-peek-always-show t)
 (lsp-ui-sideline-show-hover t)
 (lsp-ui-doc-enable nil))

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
 :init (which-key-mode)
 :config
 (which-key-setup-side-window-bottom)
 (which-key-show-major-mode)
 ;; Allow C-h to trigger which-key before it is done automatically
 (setq which-key-show-early-on-C-h t)
 ;; make sure which-key doesn't show normally but refreshes quickly after it is
 ;; triggered.
 ;; (setq which-key-sort-order 'which-key-key-order-alpha
 ;;       which-key-idle-delay 10000
 ;;       which-key-idle-secondary-delay 0.05)
 :diminish which-key-mode)

;; optionally if you want to use debugger
(use-package dap-mode :ensure t :defer t)
;; (use-package dap-LANGUAGE) to load the dap adapter for your language

;; String manipulation library
(use-package s :ensure t :defer t)

;; clang-format
(use-package
 clang-format
 :ensure t
 :after (s)
 :init
 (defun get-clang-format-option (config-str field is-num)
   "Retrieve a config option from a clang-format config.

CONFIG-STR is a string containing the entire clang-format config.
FIELD is specific option, e.g. `IndentWidth'.  IS-NUM is a
boolean that should be set to 1 if the option is numeric,
otherwise assumed alphabetic."
   (if is-num
       (let ((primary-match
              (s-match
               (concat "^" field ":[ \t]*[0-9]+") config-str)))
         (if primary-match
             (string-to-number
              (car (s-match "[0-9]+" (car primary-match))))
           0))
     (let ((primary-match
            (s-match
             (concat "^" field ":[ \t]*[A-Za-z]+") config-str)))
       (if primary-match
           (car (s-match "[A-Za-z]+$" (car primary-match)))
         ""))))
 :hook
 (c-mode-common
  .
  (lambda ()
    (let* ((clang-format-config
            (shell-command-to-string "clang-format -dump-config"))
           (c-offset
            (get-clang-format-option
             clang-format-config "IndentWidth" t))
           (tabs-str
            (get-clang-format-option
             clang-format-config "UseTab" nil))
           (base-style
            (get-clang-format-option
             clang-format-config "BasedOnStyle" nil)))
      (progn
        (if (> c-offset 0)
            (setq-local c-basic-offset c-offset)
          (if (not (equal "" base-style))
              (cond
               ((or (equal "LLVM" base-style)
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
              (cond
               ((or (equal "LLVM" base-style)
                    (equal "Google" base-style)
                    (equal "Chromium" base-style)
                    (equal "Mozilla" base-style)
                    (equal "WebKit" base-style))
                (setq-local indent-tabs-mode nil))))))))))

(use-package
 clang-format+
 :ensure t
 :config
 (add-hook 'c-mode-common-hook #'clang-format+-mode)
 (add-hook 'c-mode-hook 'clang-format+-mode)
 (setq clang-format+-context #'modification))

(use-package yaml-mode :ensure t :defer t)

;;;;;;;;;;;;;;;;;;;;;;;;; Yasipnet ;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package
 yasnippet
 :ensure t
 :defer t
 :config (yas-global-mode 1)
 (defun yas-popup-isearch-prompt (prompt choices &optional display-fn)
   (when (featurep 'popup)
     (popup-menu*
      (mapcar
       (lambda (choice)
         (popup-make-item
          (or (and display-fn (funcall display-fn choice)) choice)
          :value choice))
       choices)
      :prompt prompt
      ;; start isearch mode immediately
      :isearch t)))

 (setq yas-prompt-functions
       '(yas-popup-isearch-prompt yas-ido-prompt yas-no-prompt)))
;;;;;;;;;; END YAS ;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;; Navigation ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package
 ggtags
 :ensure t
 :requires xref
 :config
 ;; Enable helm-gtags-mode in languages that GNU Global supports
 (add-hook 'c-mode-hook 'ggtags-mode)
 (add-hook 'c-mode-hook 'xref-etags-mode)
 (add-hook 'c++-mode-hook 'ggtags-mode)
 (add-hook 'c++-mode-hook 'xref-etags-mode)
 (add-hook 'java-mode-hook 'ggtags-mode)
 (add-hook 'java-mode-hook 'xref-etags-mode)
 (add-hook 'asm-mode-hook 'ggtags-mode)
 (add-hook 'asm-mode-hook 'xref-etags-mode)
 (add-hook 'python-mode-hook 'ggtags-mode)
 (add-hook 'python-mode-hook 'xref-etags-mode)
 (add-hook 'lisp-mode-hook 'ggtags-mode)
 (add-hook 'lisp-mode-hook 'xref-etags-mode)
 (add-hook 'emacs-lisp-mode-hook 'ggtags-mode)
 (add-hook 'emacs-lisp-mode-hook 'xref-etags-mode))

;; Shell-format
(use-package
 shfmt
 :ensure t
 :defer t)

(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

;;(use-package editorconfig
;;  :ensure t)

;;(add-to-list 'load-path "~/.config/emacs/copilot.el/")
;;(load-file "~/.config/emacs/copilot.el/copilot.el")
;;(require 'copilot)
;;(add-hook 'prog-mode-hook 'copilot-mode)
;;(define-key copilot-completion-map (kbd "<tab>") 'copilot-accept-completion)
;;(define-key copilot-completion-map (kbd "TAB") 'copilot-accept-completion)
;;(setq copilot-max-char 1000000)
