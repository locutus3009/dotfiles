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
  (setq smtpmail-smtp-server "xxx") ; host running SMTP server
  (setq smtpmail-smtp-service 25)    ; SMTP service port number
  (setq smtpmail-stream-type 'plain) ; type of SMTP connections to use
  (setq smtpmail-smtp-user "xxx")
                                        ;(setq smtpmail-auth-credentials (expand-file-name "~/.authinfo.gpg"))
  (setq user-mail-address "xxx")

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
