;;; prog.el --- Programming language support -*- lexical-binding: t; -*-
;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;; tree-sitter ;;;;;;;;;;;;;;;;;;;;;;;;;
;; Grammars come from the system tree-sitter-* packages.  Each mode is only
;; enabled when its grammar is actually installed, so a machine without them
;; quietly falls back to the classic modes.
;;
;; `setopt' is required, not `setq': `treesit-enabled-modes' carries a :set
;; function that does the actual `major-mode-remap-alist' rewriting.
;;
;; Two languages are deliberately absent:
;;   Rust -- rustic owns "\\.rs\\'"; it derives from rust-ts-mode when
;;     `rust-mode-treesitter-derive' is set before rust-mode loads (below).
;;   Markdown -- `markdown-ts-mode' has no entry in
;;     `treesit-major-mode-remap-alist' and is a fraction of what the
;;     markdown-mode package does (no gfm-mode, no editing commands), so the
;;     markdown grammar stays unused here on purpose.
(defvar my/treesit-modes
  '((c-ts-mode . c)
    (c++-ts-mode . cpp)
    (python-ts-mode . python)
    (bash-ts-mode . bash)
    (lua-ts-mode . lua))
  "Tree-sitter major modes to enable, each with the grammar it needs.")

(when (and (fboundp 'treesit-available-p) (treesit-available-p))
  (setopt treesit-enabled-modes
          (mapcar #'car
                  (seq-filter (lambda (entry)
                                (treesit-language-available-p (cdr entry)))
                              my/treesit-modes))))

(defvar my/c-mode-hooks
  '(c-mode-common-hook c-ts-mode-hook c++-ts-mode-hook)
  "Every hook that has to fire for C/C++, tree-sitter or not.
`c-ts-mode' derives from `prog-mode', not from cc-mode, so it never runs
`c-mode-common-hook' -- anything hung off that alone silently stops
working once the tree-sitter modes are enabled.")

;; Formatting of elisp
(use-package elisp-autofmt
  :ensure t
  :defer t
  :config
  (setq elisp-autofmt-python-bin "python3")
  (setq elisp-autofmt-style 'native)
  (elisp-autofmt-mode t))

;; Flycheck -- syntax checking
(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode)
  (setq flycheck-rust-cargo-executable "~/.cargo/bin/cargo"))

(use-package highlight-parentheses
  :ensure t
  :hook ((prog-mode . highlight-parentheses-mode)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Rustic
;; https://robert.kra.hn/posts/rust-emacs-setup/#rustic
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun rk/rustic-mode-hook ()
  "Let `C-c C-c C-r' run without confirming the save.
Only for file-visiting buffers.  Once
https://github.com/brotzeit/rustic/issues/253 is resolved this should no
longer be necessary."
  (when buffer-file-name
    (setq-local buffer-save-without-query t))
  (add-hook 'before-save-hook 'lsp-format-buffer nil t))

(use-package rustic
  :ensure t
  :init
  ;; Makes rustic derive from rust-ts-mode instead of the regexp-based
  ;; rust-mode.  rust-mode reads this at load time, so :init is the only
  ;; place it can go.
  (setq rust-mode-treesitter-derive
        (and (fboundp 'treesit-language-available-p)
             (treesit-language-available-p 'rust)))
  :bind
  (:map rustic-mode-map
        ("M-j" . lsp-ui-imenu)
        ("M-?" . lsp-find-references)
        ("C-c C-c l" . flycheck-list-errors)
        ("C-c C-c a" . lsp-execute-code-action)
        ("C-c C-c r" . lsp-rename)
        ("C-c C-c q" . lsp-workspace-restart)
        ("C-c C-c Q" . lsp-workspace-shutdown)
        ("C-c C-c s" . lsp-rust-analyzer-status))
  :config
  ;; comment to disable rustfmt on save
  (setq rustic-format-on-save t)
  (add-hook 'rustic-mode-hook 'rk/rustic-mode-hook))

(use-package dash :ensure t :defer t)

;; Language server
(use-package lsp-mode
  :ensure t
  :init
  ;; C-c l is org-store-link (orgconf.el), so the lsp prefix lives on C-c C-l.
  (setq lsp-keymap-prefix "C-c C-l")
  (setq lsp-clients-clangd-args
        '("--compile-commands-dir=./build" "--query-driver=/**/bin/*"))
  :hook
  ((c++-mode . lsp-deferred)
   (c-mode . lsp-deferred)
   (c++-ts-mode . lsp-deferred)
   (c-ts-mode . lsp-deferred)
   ;; which-key integration
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
  (lsp-rust-analyzer-display-lifetime-elision-hints-enable "skip_trivial")
  (lsp-rust-analyzer-display-chaining-hints t)
  (lsp-rust-analyzer-display-lifetime-elision-hints-use-parameter-names nil)
  (lsp-rust-analyzer-display-closure-return-type-hints t)
  (lsp-rust-analyzer-display-parameter-hints nil)
  (lsp-rust-analyzer-display-reborrow-hints nil)

  (lsp-auto-guess-root t)
  (lsp-prefer-capf t)
  (lsp-keep-workspace-alive nil)

  ;; Performance improvements
  (lsp-completion-provider :none) ; Use company instead
  (lsp-headerline-breadcrumb-enable nil)
  (lsp-enable-file-watchers nil)  ; Big performance gain
  (lsp-enable-folding nil)
  (lsp-enable-snippet nil)
  (lsp-log-io nil))

;; No lua-mode declaration: Emacs 31 ships its own lua-mode (which registers
;; "\\.lua\\'" itself), and with the grammar present that is remapped to
;; lua-ts-mode anyway.  The MELPA package was doing neither job.

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

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :config
  (define-key lsp-ui-mode-map
              [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
  (define-key lsp-ui-mode-map
              [remap xref-find-references] #'lsp-ui-peek-find-references)
  :custom
  (lsp-ui-peek-always-show t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-doc-enable nil))

;; if you are ivy user
(use-package lsp-ivy
  :ensure t
  :after (ivy)
  :commands lsp-ivy-workspace-symbol)

;; which-key ships with Emacs since 30 -- do NOT fetch the older MELPA copy,
;; it would shadow the built-in one.
(use-package which-key
  :ensure nil
  :init (which-key-mode)
  :config
  (which-key-setup-side-window-bottom)
  ;; `which-key-show-major-mode' is an interactive command; calling it here
  ;; only produced "No map named fundamental-mode-map" at startup.
  ;; Allow C-h to trigger which-key before it is done automatically
  (setq which-key-show-early-on-C-h t)
  :diminish which-key-mode)

;; optionally if you want to use debugger
(use-package dap-mode :ensure t :defer t)

;; String manipulation library.  Demanded, not deferred: the clang-format
;; helper below calls `s-match' from a hook, and relying on some other package
;; to have pulled s in first is luck, not a dependency.
(use-package s :ensure t :demand t)

;;;;;;;;;;;;;;;;;;;;;;;;; clang-format ;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar my/clang-format-config-cache (make-hash-table :test 'equal)
  "Cache of `clang-format -dump-config' output, keyed by config directory.")

(defun my/clang-format-config ()
  "Return the clang-format config that applies to the current buffer.
The result is cached per .clang-format directory: the shell call costs
50-150ms and used to run on every single C/C++ buffer opened."
  (when (executable-find "clang-format")
    (let ((key (or (locate-dominating-file default-directory ".clang-format")
                   default-directory)))
      (or (gethash key my/clang-format-config-cache)
          (puthash key
                   (let ((default-directory key))
                     (shell-command-to-string "clang-format -dump-config"))
                   my/clang-format-config-cache)))))

(use-package clang-format
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
               (s-match (concat "^" field ":[ \t]*[0-9]+") config-str)))
          (if primary-match
              (string-to-number (car (s-match "[0-9]+" (car primary-match))))
            0))
      (let ((primary-match
             (s-match (concat "^" field ":[ \t]*[A-Za-z]+") config-str)))
        (if primary-match
            (car (s-match "[A-Za-z]+$" (car primary-match)))
          ""))))

  (defun my/set-c-indent-offset (n)
    "Set the indentation step to N for both cc-mode and the ts modes.
cc-mode reads `c-basic-offset'; `c-ts-mode' explicitly ignores it and
reads `c-ts-indent-offset' (renamed from `c-ts-mode-indent-offset' in
Emacs 31).  Setting both keeps one code path for either mode."
    (setq-local c-basic-offset n)
    (setq-local c-ts-indent-offset n))

  (defun my/apply-clang-format-style ()
    "Set the indent offset and `indent-tabs-mode' from the clang-format config."
    (when-let* ((cfg (my/clang-format-config)))
      (let ((c-offset (get-clang-format-option cfg "IndentWidth" t))
            (tabs-str (get-clang-format-option cfg "UseTab" nil))
            (base-style (get-clang-format-option cfg "BasedOnStyle" nil)))
        (if (> c-offset 0)
            (my/set-c-indent-offset c-offset)
          (unless (equal "" base-style)
            (cond
             ((member base-style '("LLVM" "Google" "Chromium" "Mozilla"))
              (my/set-c-indent-offset 2))
             ((equal "WebKit" base-style)
              (my/set-c-indent-offset 4)))))
        (if (not (equal "" tabs-str))
            (setq-local indent-tabs-mode (not (string-equal "Never" tabs-str)))
          (when (member base-style
                        '("LLVM" "Google" "Chromium" "Mozilla" "WebKit"))
            (setq-local indent-tabs-mode nil))))))
  :config
  (dolist (hook my/c-mode-hooks)
    (add-hook hook #'my/apply-clang-format-style)))

(use-package clang-format+
  :ensure t
  :config
  (dolist (hook my/c-mode-hooks)
    (add-hook hook #'clang-format+-mode))
  (setq clang-format+-context #'modification))

(use-package yaml-mode :ensure t :defer t)

;;;;;;;;;;;;;;;;;;;;;;;;; Yasnippet ;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package yasnippet
  :ensure t
  :defer t
  :config
  (yas-global-mode 1)
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

;;;;;;;;;;;;;;;;;;;;; Navigation ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ggtags installs its own xref backend.  `xref-etags-mode' used to be enabled
;; alongside it, which forced the etags backend and broke `M-.' for elisp
;; (where the native backend needs no TAGS file at all).
;; No `:requires xref' here: xref is not loaded at startup, so that guard used
;; to skip this whole block and none of the hooks below were ever installed.
(use-package ggtags
  :ensure t
  :config
  (dolist (hook '(c-mode-hook
                  c++-mode-hook
                  c-ts-mode-hook
                  c++-ts-mode-hook
                  java-mode-hook
                  asm-mode-hook
                  python-mode-hook
                  python-ts-mode-hook
                  lisp-mode-hook
                  emacs-lisp-mode-hook))
    (add-hook hook 'ggtags-mode)))

;; ripgrep front end -- the replacement for `rgrep'/`grep-find', which have no
;; rg backend of their own.  `rg-menu' is a transient with the usual switches;
;; `rg-dwim' searches the symbol at point in the project without prompting.
;; It also makes `projectile-ripgrep' (C-c C-p s r) work, which needs this
;; package to be present.
(use-package rg
  :ensure t
  :defer t
  :bind
  (("C-c s" . rg-menu)
   ("C-c S" . rg-dwim))
  :config
  (setq rg-group-result t)
  (setq rg-hide-command nil))

;; Shell-format
(use-package shfmt :ensure t :defer t)

;; editorconfig ships with Emacs since 30.
(use-package editorconfig
  :ensure nil
  :config
  (editorconfig-mode 1))

(use-package ellama
  :ensure t
  :bind ("C-c e" . ellama-transient-main-menu)   ;; меню всех команд
  :init
  (setopt ellama-language "Russian")             ;; язык ответов (или "English")
  (require 'llm-ollama)
  ;; основной провайдер — код-вопросы
  (setopt ellama-provider
          (make-llm-ollama
           :chat-model "qwen3-coder:30b"
           :embedding-model "nomic-embed-text"))  ;; для контекста/RAG
  :config
  ;; лёгкая модель для служебных задач (названия сессий и т.п.)
  (setopt ellama-naming-provider
          (make-llm-ollama :chat-model "qwen2.5-coder:7b")))

(provide 'prog)
;;; prog.el ends here
