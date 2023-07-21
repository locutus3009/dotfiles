;;; my-init --- My personal init.el file
;;; Commentary:
;;; Just checkout and use it

;;; Code:

;; Main setup that must be done before execution of any code
(load-file "~/.config/emacs/main.el")

;; Theme
(load-file "~/.config/emacs/theme.el")

;; Substitution, completion, selection and suggestions
(load-file "~/.config/emacs/completion.el")

;; Projects and source control
(load-file "~/.config/emacs/projects.el")

;; General editing
(load-file "~/.config/emacs/edit.el")

;; Programming language support
(load-file "~/.config/emacs/prog.el")

;; Fine-tuning org-mode
(load-file "~/.config/emacs/agenda.el")

;; Mail
;; (load-file "~/.config/emacs/mail.el")

;; Other custom keys
(load-file "~/.config/emacs/keys.el")

;; Treemacs setup & file browsing
;; (load-file "~/.config/emacs/treemacs.el")

;; Startup dashboard
(load-file "~/.config/emacs/dashboard.el")
