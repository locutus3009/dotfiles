;; Integration with GitLab
(use-package ivy-gitlab :ensure t)

(use-package
 gitlab
 :ensure t
 :config
 ;; Gitlab
 (global-set-key (kbd "\C-c\C-x g i") 'ivy-gitlab-list-all-issues)
 (global-set-key (kbd "\C-c\C-x g p") 'ivy-gitlab-list-projects)
 (setq
  gitlab-host "HOST"
  gitlab-token-id "TOKEN"))

(defun gitlab-issue-status-to-org (issue)
  (cond
   ((string= (assoc-default 'state issue) "opened")
    (if (assoc-default 'assignee issue)
        "NEXT"
      "TODO"))
   ;; ((string= (assoc-default 'state issue) "active")
   ;;  "NEXT")
   ((string= (assoc-default 'state issue) "closed")
    "DONE")
   (t
    (assoc-default 'state issue))))

(defun gitlab-to-org ()
  (interactive)
  (with-temp-buffer
    (insert "# -*- buffer-read-only: t -*-")
    (end-of-line)
    (newline)
    (insert "* Gitlab issues")
    (end-of-line)
    (newline)
    (insert "#+CATEGORY: Gitlab")
    (end-of-line)
    (newline)
    (mapc
     (lambda (issue)
       (insert
        "** "
        (gitlab-issue-status-to-org issue)
        " "
        "#"
        (number-to-string (assoc-default 'iid issue))
        " "
        (assoc-default 'title issue)
        " :GITLAB:")
       (when (assoc-default 'assignee issue)
         (end-of-line)
         (newline)
         (insert ":PROPERTIES:")
         (end-of-line)
         (newline)
         (insert
          ":assigned:"
          (assoc-default 'name (assoc-default 'assignee issue)))
         (end-of-line)
         (newline)
         (insert ":END:"))
       (end-of-line)
       (newline)
       (insert
        "[["
        gitlab-host
        "/"
        (assoc-default
         `path_with_namespace
         (gitlab-get-project (assoc-default 'project_id issue)))
        "/issues/"
        (number-to-string (assoc-default 'iid issue))
        "]["
        "#"
        (number-to-string (assoc-default 'iid issue))
        " "
        (assoc-default 'title issue)
        "]]")
       (end-of-line)
       (newline)
       (insert
        "Project: "
        (assoc-default
         `path_with_namespace
         (gitlab-get-project (assoc-default 'project_id issue))))
       (end-of-line)
       (newline)
       (insert "Description:")
       (end-of-line)
       (newline)
       (insert (assoc-default 'description issue))
       (end-of-line)
       (newline)
       (end-of-line)
       (newline))
     (gitlab-list-all-issues))
    (end-of-line)
    (newline)
    (end-of-line)
    (newline)
    (insert "#+LINK: gitlab  " gitlab-host)
    (buffer-string)))

(defun emacs-gitlab-to-org-file ()
  (interactive)
  (let ((file "~/ORG/gitlab.org"))
    (with-temp-file file
      (insert (gitlab-to-org)))))
