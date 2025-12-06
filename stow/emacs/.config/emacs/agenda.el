(use-package
  org
  :ensure t
  :config
  ;; (org :variables
  ;;      org-enable-jira-support t
  ;;      org-jira-working-dir "~/ORG/")

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

  ;; Default notes file
  (setq org-default-notes-file "~/ORG/notes.org")

  ;; Define the custum capture templates
  (setq org-capture-templates '(("t" "todo" entry (file org-default-notes-file)
				 "* TODO %?\n%u\n%a\n"
				 :clock-in t
				 :clock-resume t)
				("m" "Meeting" entry (file org-default-notes-file)
				 "* MEETING with %? :MEETING:\n%t\n%a\n"
				 :clock-in t
				 :clock-resume t)
				("j" "Journal" entry (file+datetree "~/ORG/journal.org")
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
  (setq org-agenda-files (append (file-expand-wildcards "~/ORG/*.org") (file-expand-wildcards "~/mnt/ORG/*.org"))))
