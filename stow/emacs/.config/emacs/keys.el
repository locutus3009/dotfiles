;;; keys.el --- Other custom keys -*- lexical-binding: t; -*-
;;; Code:

;; NOTE: TAB used to be globally rebound to `tab-to-tab-stop' here.  That
;; stole the key from company (complete) and yasnippet (expand), both of which
;; are enabled globally.  If the old behaviour is wanted back, scope it:
;;   (define-key text-mode-map (kbd "TAB") #'tab-to-tab-stop)

;; Disable non-natural cursor movement
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

;; Strip mouse usage
(global-unset-key (kbd "<mouse-2>"))
(global-unset-key (kbd "<mouse-3>"))

;; Movement between windows
(global-set-key (kbd "C-x p") 'windmove-up)
(global-set-key (kbd "C-x n") 'windmove-down)
(global-set-key (kbd "C-x .") 'windmove-right)
(global-set-key (kbd "C-x ,") 'windmove-left)
(global-set-key (kbd "C-x C-.") 'windmove-right)
(global-set-key (kbd "C-x C-,") 'windmove-left)

(provide 'keys)
;;; keys.el ends here
