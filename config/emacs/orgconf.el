;; (use-package org-habit-stats :ensure t)

(use-package
 org
 :ensure t
 :config
 ;; (org :variables
 ;;      org-enable-jira-support t
 ;;      org-jira-working-dir "~/ORG/")
 ;; Enable habits module
 (add-to-list 'org-modules 'org-habit t))

;;;;;;;;;;;
;; Plantuml
;;;;;;;;;;;
(use-package
 plantuml-mode
 :disabled
 :config
 (setq org-plantuml-jar-path (expand-file-name "~/bin/plantuml.jar"))
 (add-to-list 'org-src-lang-modes '("plantuml" . plantuml))
 (org-babel-do-load-languages
  'org-babel-load-languages '((plantuml . t))))

;; Sequences of keywords used in org-mode
(setq org-todo-keywords
      (quote ((sequence
               "TODO(t)" "NEXT(n)" "IN_REVIEW(r)" "|" "DONE(d)")
              (sequence
               "WAITING(w@/!)"
               "HOLD(h@/!)"
               "|"
               "CANCELLED(c@/!)"
               "PHONE"
               "MEETING"))))

;; Set colors for org-mode keywords
(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
              ("NEXT" :foreground "blue" :weight bold)
              ("DONE" :foreground "green " :weight bold)
              ("WAITING" :foreground "orange" :weight bold)
              ("HOLD" :foreground "magenta" :weight bold)
              ("CANCELLED" :foreground "yellow" :weight bold)
              ("MEETING" :foreground "yellow" :weight bold)
              ("PHONE" :foreground "yellow" :weight bold)
              ("IN_REVIEW" :foreground "orange" :weight bold))))

;; Set follow rules
(setq org-todo-state-tags-triggers
      (quote (("CANCELLED" ("CANCELLED" . t))
              ("WAITING" ("WAITING" . t))
              ("HOLD" ("WAITING") ("HOLD" . t))
              (done ("WAITING") ("HOLD"))
              ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
              ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
              ("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))

;; Follow mode
(add-hook 'org-agenda-mode-hook #'org-agenda-follow-mode)

;; Always enable certain modes with org-mode
(add-hook 'org-mode-hook 'auto-fill-mode)

;; Default notes file
(setq org-default-notes-file "~/ORG/refile.org")

;; Define the custum capture templates
(setq
 org-capture-templates
 '(("t"
    "todo"
    entry
    (file org-default-notes-file)
    "* TODO %?\n%u\n%a\n"
    :clock-in t
    :clock-resume t)
   ("m"
    "Meeting"
    entry
    (file org-default-notes-file)
    "* MEETING with %? :MEETING:\n%t\n%a\n"
    :clock-in t
    :clock-resume t)
   ("o"
    "Journal clocked"
    entry
    (file+datetree "~/ORG/journal.org")
    "* %? :JOURNAL:\n%t\n%a\n"
    :clock-in t
    :clock-resume t)
   ("j"
    "Journal"
    entry
    (file+datetree "~/ORG/journal.org")
    "* %? :JOURNAL:\n%t\n%U\n%i\n%a\n"
    :clock-in t
    :clock-resume t)
   ("i"
    "Idea"
    entry
    (file org-default-notes-file)
    "* %? :IDEA:\n%t\n%a\n"
    :clock-in t
    :clock-resume t)
   ("h"
    "Habit"
    entry
    (file "~/ORG/habits.org")
    "* NEXT %? :HABIT:\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d/3d>>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n%u\n%a\n")
   ("n"
    "Next Task"
    entry
    (file+headline org-default-notes-file "Tasks")
    "** NEXT %? \nDEADLINE: %t")
   ("d"
 "Daily Journal"
 entry
 (file+datetree "~/ORG/journal.org")
 "* Daily Journal :JOURNAL:\n%U\n\n** What did I learn about myself today?\n- %?\n\n** My leisure activities:\n- \n\n** Successes of the day:\n- \n\n** What did I do for myself?\n- \n\n** What did I do for my family?\n- "
 :clock-in t
 :clock-resume t)))

(setq
 org-clock-clocktable-default-properties
 (quote (:maxlevel 10 :emphasize t :compact t :ident t))
 org-time-clocksum-format '(:hours "%d" :require-hours t :minutes ":%02d" :require-minutes t))
(setq org-duration-format (quote h:mm))

(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)

(setq org-refile-targets
      (quote ((nil :maxlevel . 9) (org-agenda-files :maxlevel . 9))))

; Use full outline paths for refile targets - we file directly with IDO
(setq org-refile-use-outline-path t)

; Targets complete directly with IDO
(setq org-outline-path-complete-in-steps nil)

; Allow refile to create parent tasks with confirmation
(setq org-refile-allow-creating-parent-nodes (quote confirm))

;;;; Refile settings
; Exclude DONE state tasks from refile targets
(defun bh/verify-refile-target ()
  "Exclude todo keywords with a done state from refile targets"
  (not (member (nth 2 (org-heading-components)) org-done-keywords)))

(setq org-refile-target-verify-function 'bh/verify-refile-target)
;;;;;;;

(setq org-agenda-start-on-weekday 1)
(setq calendar-week-start-day 1)
(require 'epa-file)
(epa-file-enable)
(require 'org-tempo)

;; Set to <your Dropbox root directory>/MobileOrg.
(setq org-directory "~/ORG")

(setq org-agenda-files
      (append
       (file-expand-wildcards "~/ORG/*.org")))
(setq org-agenda-start-with-log-mode t)
;; Log creation time of TODO also
(setq org-treat-insert-todo-heading-as-state-change t)
;; log into LOGBOOK drawer
(setq org-log-into-drawer t)
;; Display habits on agenda view
(setq org-habit-show-all-today t)
;; Hide text format modifiers
(setq org-hide-emphasis-markers t)
;; Record timestamp when task is done
(setq org-log-done 'time)

;; Key bindings
(global-set-key (kbd "C-c C-x C-r") 'org-clock-report)
(global-set-key (kbd "C-c C-x C-j") 'org-clock-jump-to-current-clock)
;; (global-set-key (kbd "C-c t") 'org-timeline)
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c b") 'org-switchb)
;; (global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-M-;") 'org/capture-todo)
(global-set-key (kbd "C-M-'") 'ort/capture-checkitem)
(global-set-key (kbd "C-M-`") 'ort/goto-todos)

(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))

(setq org-capture-use-agenda-date t)

(defun org-export-string-hack
    (string backend &optional body-only ext-plist)
  (org-export-string-as
   (concat "#+OPTIONS: tex:dvipng toc:nil" string) 'html t))
;;  (org-export-string-as (concat "" string) 'html t))
(defalias 'org-export-string 'org-export-string-hack)

;;;;;;;
;;   Custom agenda
;;
;; Do not dim blocked tasks
(setq org-agenda-dim-blocked-tasks nil)

;; Compact the block agenda view
(setq org-agenda-compact-blocks t)

;;;;;;;
;;   Custom agenda
;;
;; Do not dim blocked tasks
(setq org-agenda-dim-blocked-tasks nil)

;; Compact the block agenda view
(setq org-agenda-compact-blocks t)
(defun bh/hide-other ()
  (interactive)
  (save-excursion
    (org-back-to-heading 'invisible-ok)
    (hide-other)
    (org-cycle)
    (org-cycle)
    (org-cycle)))

(defun bh/set-truncate-lines ()
  "Toggle value of truncate-lines and refresh window display."
  (interactive)
  (setq truncate-lines (not truncate-lines))
  ;; now refresh window display (an idiom from simple.el):
  (save-excursion
    (set-window-start
     (selected-window) (window-start (selected-window)))))

(defun bh/make-org-scratch ()
  (interactive)
  (find-file "/tmp/publish/scratch.org")
  (gnus-make-directory "/tmp/publish"))

(defun bh/switch-to-scratch ()
  (interactive)
  (switch-to-buffer "*scratch*"))

;; Custom agenda command definitions
(setq
 org-agenda-custom-commands
 (quote
  (("N" "Notes" tags "NOTE"
    ((org-agenda-overriding-header "Notes")
     (org-tags-match-list-sublevels t)))
   ("h" "Habits" tags-todo "STYLE=\"habit\""
    ((org-agenda-overriding-header "Habits")
     (org-agenda-sorting-strategy
      '(todo-state-down effort-up category-keep))))
   ("D"
    "Events"
    agenda
    "display deadlines (2 months) and exclude scheduled"
    ((org-agenda-span 62) ;; 'month
     (org-agenda-time-grid nil) (org-agenda-show-all-dates nil)
     (org-agenda-entry-types '(:deadline)) ;; this entry excludes :scheduled
     ))
   ("S" "Events" agenda "display scheduled"
    ((org-agenda-span 62)
     (org-agenda-time-grid nil) (org-agenda-show-all-dates nil)
     (org-agenda-entry-types '(:scheduled)) ;; this entry excludes :scheduled
     ))
   ("m" "Agenda"
    ((agenda "" nil)
     (tags
      "REFILE"
      ((org-agenda-overriding-header "Tasks to Refile")
       (org-tags-match-list-sublevels nil)))
     (tags-todo
      "-CANCELLED/!"
      ((org-agenda-overriding-header "Stuck Projects")
       (org-agenda-skip-function 'bh/skip-non-stuck-projects)
       (org-agenda-sorting-strategy '(category-keep))))
     (tags-todo
      "-HOLD-CANCELLED/!"
      ((org-agenda-overriding-header "Projects")
       (org-agenda-skip-function 'bh/skip-non-projects)
       (org-tags-match-list-sublevels 'indented)
       (org-agenda-sorting-strategy '(category-keep))))
     (tags-todo
      "-CANCELLED/!NEXT"
      ((org-agenda-overriding-header
        (concat
         "Project Next Tasks"
         (if bh/hide-scheduled-and-waiting-next-tasks
             ""
           " (including WAITING and SCHEDULED tasks)")))
       (org-agenda-skip-function
        'bh/skip-projects-and-habits-and-single-tasks)
       (org-tags-match-list-sublevels t)
       (org-agenda-todo-ignore-scheduled
        bh/hide-scheduled-and-waiting-next-tasks)
       (org-agenda-todo-ignore-deadlines
        bh/hide-scheduled-and-waiting-next-tasks)
       (org-agenda-todo-ignore-with-date
        bh/hide-scheduled-and-waiting-next-tasks)
       (org-agenda-sorting-strategy
        '(todo-state-down effort-up category-keep))))
     (tags-todo
      "-REFILE-CANCELLED-WAITING-HOLD/!"
      ((org-agenda-overriding-header
        (concat
         "Project Subtasks"
         (if bh/hide-scheduled-and-waiting-next-tasks
             ""
           " (including WAITING and SCHEDULED tasks)")))
       (org-agenda-skip-function 'bh/skip-non-project-tasks)
       (org-agenda-todo-ignore-scheduled
        bh/hide-scheduled-and-waiting-next-tasks)
       (org-agenda-todo-ignore-deadlines
        bh/hide-scheduled-and-waiting-next-tasks)
       (org-agenda-todo-ignore-with-date
        bh/hide-scheduled-and-waiting-next-tasks)
       (org-agenda-sorting-strategy '(category-keep))))
     (tags-todo
      "-REFILE-CANCELLED-WAITING-HOLD/!"
      ((org-agenda-overriding-header
        (concat
         "Standalone Tasks"
         (if bh/hide-scheduled-and-waiting-next-tasks
             ""
           " (including WAITING and SCHEDULED tasks)")))
       (org-agenda-skip-function 'bh/skip-project-tasks)
       (org-agenda-todo-ignore-scheduled
        bh/hide-scheduled-and-waiting-next-tasks)
       (org-agenda-todo-ignore-deadlines
        bh/hide-scheduled-and-waiting-next-tasks)
       (org-agenda-todo-ignore-with-date
        bh/hide-scheduled-and-waiting-next-tasks)
       (org-agenda-sorting-strategy '(category-keep))))
     (tags-todo
      "-CANCELLED+WAITING|HOLD/!"
      ((org-agenda-overriding-header
        (concat
         "Waiting and Postponed Tasks"
         (if bh/hide-scheduled-and-waiting-next-tasks
             ""
           " (including WAITING and SCHEDULED tasks)")))
       (org-agenda-skip-function 'bh/skip-non-tasks)
       (org-tags-match-list-sublevels nil)
       (org-agenda-todo-ignore-scheduled
        bh/hide-scheduled-and-waiting-next-tasks)
       (org-agenda-todo-ignore-deadlines
        bh/hide-scheduled-and-waiting-next-tasks)))
     (tags
      "-REFILE-HABIT-IDEA-GITLAB/"
      ((org-agenda-overriding-header "Tasks to Archive")
       (org-agenda-skip-function
        'bh/skip-non-archivable-tasks)
       (org-tags-match-list-sublevels nil))))
    nil))))
;;;;;;;

;;;;;;;
;;   Clock stetup
;;;;;;;
;;
;; Resume clocking task when emacs is restarted
(org-clock-persistence-insinuate)
;;
;; Show lot of clocking history so it's easy to pick items off the C-F11 list
(setq org-clock-history-length 23)
;; Resume clocking task on clock-in if the clock is open
(setq org-clock-in-resume t)
;; Change tasks to NEXT when clocking in
(setq org-clock-in-switch-to-state 'bh/clock-in-to-next)
;; Separate drawers for clocking and logs
(setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))
;; Save clock data and state changes and notes in the LOGBOOK drawer
(setq org-clock-into-drawer t)
;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)
;; Clock out when moving task to a done state
(setq org-clock-out-when-done t)
;; Save the running clock and all clock history when exiting Emacs, load it on startup
(setq org-clock-persist t)
;; Do not prompt to resume an active clock
(setq org-clock-persist-query-resume nil)
;; Enable auto clock resolution for finding open clocks
(setq org-clock-auto-clock-resolution
      (quote when-no-clock-is-running))
;; Include current clocking task in clock reports
(setq org-clock-report-include-clocking-task t)

(setq bh/keep-clock-running nil)

(defun bh/clock-in-to-next (kw)
  "Switch a task from TODO to NEXT when clocking in.
Skips capture tasks, projects, and subprojects.
Switch projects and subprojects from NEXT back to TODO"
  (when (not (and (boundp 'org-capture-mode) org-capture-mode))
    (cond
     ((and (member (org-get-todo-state) (list "TODO")) (bh/is-task-p))
      "NEXT")
     ((and (member (org-get-todo-state) (list "NEXT"))
           (bh/is-project-p))
      "TODO"))))

(setq org-archive-mark-done nil)
(setq org-archive-location "%s_archive::* Archived Tasks")

(defun bh/skip-non-archivable-tasks ()
  "Skip trees that are not available for archiving"
  (save-restriction
    (widen)
    ;; Consider only tasks with done todo headings as archivable candidates
    (let ((next-headline
           (save-excursion (or (outline-next-heading) (point-max))))
          (subtree-end (save-excursion (org-end-of-subtree t))))
      (if (member (org-get-todo-state) org-todo-keywords-1)
          (if (member (org-get-todo-state) org-done-keywords)
              (let* ((daynr
                      (string-to-number
                       (format-time-string "%d" (current-time))))
                     (a-month-ago (* 60 60 24 (+ daynr 1)))
                     (last-month
                      (format-time-string "%Y-%m-"
                                          (time-subtract
                                           (current-time)
                                           (seconds-to-time
                                            a-month-ago))))
                     (this-month
                      (format-time-string "%Y-%m-" (current-time)))
                     (subtree-is-current
                      (save-excursion
                        (forward-line 1)
                        (and (< (point) subtree-end)
                             (re-search-forward (concat
                                                 last-month
                                                 "\\|"
                                                 this-month)
                                                subtree-end t)))))
                (if subtree-is-current
                    subtree-end ; Has a date in this month or last month, skip it
                  nil)) ; available to archive
            (or subtree-end (point-max)))
        next-headline))))

(defun bh/find-project-task ()
  "Move point to the parent (project) task if any"
  (save-restriction
    (widen)
    (let ((parent-task
           (save-excursion
             (org-back-to-heading 'invisible-ok)
             (point))))
      (while (org-up-heading-safe)
        (when (member
               (nth 2 (org-heading-components)) org-todo-keywords-1)
          (setq parent-task (point))))
      (goto-char parent-task)
      parent-task)))

(defun bh/punch-in (arg)
  "Start continuous clocking and set the default task to the
selected task.  If no task is selected set the Organization task
as the default task."
  (interactive "p")
  (setq bh/keep-clock-running t)
  (if (equal major-mode 'org-agenda-mode)
      ;;
      ;; We're in the agenda
      ;;
      (let* ((marker (org-get-at-bol 'org-hd-marker))
             (tags (org-with-point-at marker (org-get-tags-at))))
        (if (and (eq arg 4) tags)
            (org-agenda-clock-in '(16))
          (bh/clock-in-organization-task-as-default)))
    ;;
    ;; We are not in the agenda
    ;;
    (save-restriction
      (widen)
      ; Find the tags on the current task
      (if (and (equal major-mode 'org-mode)
               (not (org-before-first-heading-p))
               (eq arg 4))
          (org-clock-in '(16))
        (bh/clock-in-organization-task-as-default)))))

(defun bh/punch-out ()
  (interactive)
  (setq bh/keep-clock-running nil)
  (when (org-clock-is-active)
    (org-clock-out))
  (org-agenda-remove-restriction-lock))

(defun bh/clock-in-default-task ()
  (save-excursion
    (org-with-point-at org-clock-default-task (org-clock-in))))

(defun bh/clock-in-parent-task ()
  "Move point to the parent (project) task if any and clock in"
  (let ((parent-task))
    (save-excursion
      (save-restriction
        (widen)
        (while (and (not parent-task) (org-up-heading-safe))
          (when (member
                 (nth 2 (org-heading-components)) org-todo-keywords-1)
            (setq parent-task (point))))
        (if parent-task
            (org-with-point-at parent-task (org-clock-in))
          (when bh/keep-clock-running
            (bh/clock-in-default-task)))))))

(defvar bh/organization-task-id
  "eb155a82-92b2-4f25-a3c6-0304591af2f9")

(defun bh/clock-in-organization-task-as-default ()
  (interactive)
  (org-with-point-at
   (org-id-find bh/organization-task-id 'marker)
   (org-clock-in '(16))))

(defun bh/clock-out-maybe ()
  (when (and bh/keep-clock-running
             (not org-clock-clocking-in)
             (marker-buffer org-clock-default-task)
             (not org-clock-resolving-clocks-due-to-idleness))
    (bh/clock-in-parent-task)))

(add-hook 'org-clock-out-hook 'bh/clock-out-maybe 'append)

(require 'org-id)
(defun bh/clock-in-task-by-id (id)
  "Clock in a task by id"
  (org-with-point-at (org-id-find id 'marker) (org-clock-in nil)))

(defun bh/clock-in-last-task (arg)
  "Clock in the interrupted task if there is one
Skip the default task and get the next one.
A prefix arg forces clock in of the default task."
  (interactive "p")
  (let ((clock-in-to-task
         (cond
          ((eq arg 4)
           org-clock-default-task)
          ((and (org-clock-is-active)
                (equal
                 org-clock-default-task (cadr org-clock-history)))
           (caddr org-clock-history))
          ((org-clock-is-active)
           (cadr org-clock-history))
          ((equal org-clock-default-task (car org-clock-history))
           (cadr org-clock-history))
          (t
           (car org-clock-history)))))
    (widen)
    (org-with-point-at clock-in-to-task (org-clock-in nil))))
;;;;;;;


;;;;;;
;;   GTD
;;;;;;
(defun bh/is-project-p ()
  "Any task with a todo keyword subtask"
  (save-restriction
    (widen)
    (let ((has-subtask)
          (subtree-end (save-excursion (org-end-of-subtree t)))
          (is-a-task
           (member
            (nth 2 (org-heading-components)) org-todo-keywords-1)))
      (save-excursion
        (forward-line 1)
        (while (and (not has-subtask)
                    (< (point) subtree-end)
                    (re-search-forward "^\*+ " subtree-end t))
          (when (member (org-get-todo-state) org-todo-keywords-1)
            (setq has-subtask t))))
      (and is-a-task has-subtask))))

(defun bh/is-project-subtree-p ()
  "Any task with a todo keyword that is in a project subtree.
Callers of this function already widen the buffer view."
  (let ((task
         (save-excursion
           (org-back-to-heading 'invisible-ok)
           (point))))
    (save-excursion
      (bh/find-project-task)
      (if (equal (point) task)
          nil
        t))))

(defun bh/is-task-p ()
  "Any task with a todo keyword and no subtask"
  (save-restriction
    (widen)
    (let ((has-subtask)
          (subtree-end (save-excursion (org-end-of-subtree t)))
          (is-a-task
           (member
            (nth 2 (org-heading-components)) org-todo-keywords-1)))
      (save-excursion
        (forward-line 1)
        (while (and (not has-subtask)
                    (< (point) subtree-end)
                    (re-search-forward "^\*+ " subtree-end t))
          (when (member (org-get-todo-state) org-todo-keywords-1)
            (setq has-subtask t))))
      (and is-a-task (not has-subtask)))))

(defun bh/is-subproject-p ()
  "Any task which is a subtask of another project"
  (let ((is-subproject)
        (is-a-task
         (member
          (nth 2 (org-heading-components)) org-todo-keywords-1)))
    (save-excursion
      (while (and (not is-subproject) (org-up-heading-safe))
        (when (member
               (nth 2 (org-heading-components)) org-todo-keywords-1)
          (setq is-subproject t))))
    (and is-a-task is-subproject)))

(defun bh/list-sublevels-for-projects-indented ()
  "Set org-tags-match-list-sublevels so when restricted to a subtree we list all subtasks.
  This is normally used by skipping functions where this variable is already local to the agenda."
  (if (marker-buffer org-agenda-restrict-begin)
      (setq org-tags-match-list-sublevels 'indented)
    (setq org-tags-match-list-sublevels nil))
  nil)

(defun bh/list-sublevels-for-projects ()
  "Set org-tags-match-list-sublevels so when restricted to a subtree we list all subtasks.
  This is normally used by skipping functions where this variable is already local to the agenda."
  (if (marker-buffer org-agenda-restrict-begin)
      (setq org-tags-match-list-sublevels t)
    (setq org-tags-match-list-sublevels nil))
  nil)

(defvar bh/hide-scheduled-and-waiting-next-tasks t)

(defun bh/toggle-next-task-display ()
  (interactive)
  (setq bh/hide-scheduled-and-waiting-next-tasks
        (not bh/hide-scheduled-and-waiting-next-tasks))
  (when (equal major-mode 'org-agenda-mode)
    (org-agenda-redo))
  (message "%s WAITING and SCHEDULED NEXT Tasks"
           (if bh/hide-scheduled-and-waiting-next-tasks
               "Hide"
             "Show")))

(defun bh/skip-stuck-projects ()
  "Skip trees that are not stuck projects"
  (save-restriction
    (widen)
    (let ((next-headline
           (save-excursion (or (outline-next-heading) (point-max)))))
      (if (bh/is-project-p)
          (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
                 (has-next))
            (save-excursion
              (forward-line 1)
              (while (and (not has-next)
                          (< (point) subtree-end)
                          (re-search-forward "^\\*+ NEXT "
                                             subtree-end
                                             t))
                (unless (member "WAITING" (org-get-tags-at))
                  (setq has-next t))))
            (if has-next
                nil
              next-headline)) ; a stuck project, has subtasks but no next task
        nil))))

(defun bh/skip-non-stuck-projects ()
  "Skip trees that are not stuck projects"
  ;; (bh/list-sublevels-for-projects-indented)
  (save-restriction
    (widen)
    (let ((next-headline
           (save-excursion (or (outline-next-heading) (point-max)))))
      (if (bh/is-project-p)
          (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
                 (has-next))
            (save-excursion
              (forward-line 1)
              (while (and (not has-next)
                          (< (point) subtree-end)
                          (re-search-forward "^\\*+ NEXT "
                                             subtree-end
                                             t))
                (unless (member "WAITING" (org-get-tags-at))
                  (setq has-next t))))
            (if has-next
                next-headline
              nil)) ; a stuck project, has subtasks but no next task
        next-headline))))

(defun bh/skip-non-projects ()
  "Skip trees that are not projects"
  ;; (bh/list-sublevels-for-projects-indented)
  (if (save-excursion (bh/skip-non-stuck-projects))
      (save-restriction
        (widen)
        (let ((subtree-end (save-excursion (org-end-of-subtree t))))
          (cond
           ((bh/is-project-p)
            nil)
           ((and (bh/is-project-subtree-p) (not (bh/is-task-p)))
            nil)
           (t
            subtree-end))))
    (save-excursion (org-end-of-subtree t))))

(defun bh/skip-non-tasks ()
  "Show non-project tasks.
Skip project and sub-project tasks, habits, and project related tasks."
  (save-restriction
    (widen)
    (let ((next-headline
           (save-excursion (or (outline-next-heading) (point-max)))))
      (cond
       ((bh/is-task-p)
        nil)
       (t
        next-headline)))))

(defun bh/skip-project-trees-and-habits ()
  "Skip trees that are projects"
  (save-restriction
    (widen)
    (let ((subtree-end (save-excursion (org-end-of-subtree t))))
      (cond
       ((bh/is-project-p)
        subtree-end)
       ((org-is-habit-p)
        subtree-end)
       (t
        nil)))))

(defun bh/skip-projects-and-habits-and-single-tasks ()
  "Skip trees that are projects, tasks that are habits, single non-project tasks"
  (save-restriction
    (widen)
    (let ((next-headline
           (save-excursion (or (outline-next-heading) (point-max)))))
      (cond
       ((org-is-habit-p)
        next-headline)
       ((and bh/hide-scheduled-and-waiting-next-tasks
             (member "WAITING" (org-get-tags-at)))
        next-headline)
       ((bh/is-project-p)
        next-headline)
       ((and (bh/is-task-p) (not (bh/is-project-subtree-p)))
        next-headline)
       (t
        nil)))))

(defun bh/skip-project-tasks-maybe ()
  "Show tasks related to the current restriction.
When restricted to a project, skip project and sub project tasks, habits, NEXT tasks, and loose tasks.
When not restricted, skip project and sub-project tasks, habits, and project related tasks."
  (save-restriction
    (widen)
    (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
           (next-headline
            (save-excursion (or (outline-next-heading) (point-max))))
           (limit-to-project
            (marker-buffer org-agenda-restrict-begin)))
      (cond
       ((bh/is-project-p)
        next-headline)
       ((org-is-habit-p)
        subtree-end)
       ((and (not limit-to-project) (bh/is-project-subtree-p))
        subtree-end)
       ((and limit-to-project
             (bh/is-project-subtree-p)
             (member (org-get-todo-state) (list "NEXT")))
        subtree-end)
       (t
        nil)))))

(defun bh/skip-project-tasks ()
  "Show non-project tasks.
Skip project and sub-project tasks, habits, and project related tasks."
  (save-restriction
    (widen)
    (let* ((subtree-end (save-excursion (org-end-of-subtree t))))
      (cond
       ((bh/is-project-p)
        subtree-end)
       ((org-is-habit-p)
        subtree-end)
       ((bh/is-project-subtree-p)
        subtree-end)
       (t
        nil)))))

(defun bh/skip-non-project-tasks ()
  "Show project tasks.
Skip project and sub-project tasks, habits, and loose non-project tasks."
  (save-restriction
    (widen)
    (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
           (next-headline
            (save-excursion (or (outline-next-heading) (point-max)))))
      (cond
       ((bh/is-project-p)
        next-headline)
       ((org-is-habit-p)
        subtree-end)
       ((and (bh/is-project-subtree-p)
             (member (org-get-todo-state) (list "NEXT")))
        subtree-end)
       ((not (bh/is-project-subtree-p))
        subtree-end)
       (t
        nil)))))

(defun bh/skip-projects-and-habits ()
  "Skip trees that are projects and tasks that are habits"
  (save-restriction
    (widen)
    (let ((subtree-end (save-excursion (org-end-of-subtree t))))
      (cond
       ((bh/is-project-p)
        subtree-end)
       ((org-is-habit-p)
        subtree-end)
       (t
        nil)))))

(defun bh/skip-non-subprojects ()
  "Skip trees that are not projects"
  (let ((next-headline (save-excursion (outline-next-heading))))
    (if (bh/is-subproject-p)
        nil
      next-headline)))

;;;;;;
