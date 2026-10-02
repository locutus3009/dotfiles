;;; blog.el --- nerovny.org: posts, preview, deploy -*- lexical-binding: t; -*-
;;; Commentary:
;; The site is plain Hugo with native org content (~/dev/website).
;;   C-c w n  new post (asks for title and language, creates a draft)
;;   C-c w p  preview: `hugo server -D' + browser
;;   C-c w o  open the site directory
;;   C-c w u  refresh publications from ORCID (`make publications')
;;   C-c w d  deploy (`make deploy')
;; Org and markdown buffers inside the site get spell checking in all
;; installed site languages (hunspell en_US / ru_RU / de_DE).
;;; Code:

(require 'subr-x)
(declare-function ispell-set-spellchecker-params "ispell")
(declare-function ispell-hunspell-add-multi-dic "ispell")

(defvar website-dir (expand-file-name "~/dev/website/")
  "Checkout of the nerovny.org Hugo site.")

(defvar website-languages '("en" "ru" "de")
  "Site languages; the first one is the default.")

(defvar website-preview-url "http://localhost:1313/"
  "URL of `hugo server'.")

(defun website--slug (title)
  "Turn TITLE into a file name slug (latin only; type one for other scripts)."
  (let ((s (downcase (string-trim title))))
    (setq s (replace-regexp-in-string "[^a-z0-9]+" "-" s))
    (string-trim s "-+" "-+")))

(defun website-new-post (title lang)
  "Create a draft post TITLE in language LANG and open it."
  (interactive
   (list (read-string "Title: ")
         (completing-read "Language: " website-languages nil t nil nil
                          (car website-languages))))
  (let* ((default (website--slug title))
         (slug (read-string "Slug: " (unless (string-empty-p default) default)))
         (file (expand-file-name (format "content/posts/%s.%s.org" slug lang)
                                 website-dir)))
    (when (string-empty-p slug) (user-error "Empty slug"))
    (when (file-exists-p file) (user-error "Already exists: %s" file))
    (find-file file)
    (insert (format "#+title: %s\n#+date: %s\n#+tags[]: \n#+draft: true\n\n"
                    title (format-time-string "%Y-%m-%d")))
    (message "Draft post; remove #+draft to publish. Translation: %s.<lang>.org" slug)))

(defun website--compile (command buffer)
  "Run COMMAND in `website-dir', output in BUFFER."
  (let ((default-directory website-dir)
        (compilation-buffer-name-function (lambda (_) buffer)))
    (compile command)))

(defun website-preview ()
  "Start `hugo server' with drafts (once) and open the preview."
  (interactive)
  (let ((default-directory website-dir))
    (unless (get-buffer-process "*website-preview*")
      (start-process "website-preview" "*website-preview*"
                     "hugo" "server" "-D" "--bind" "127.0.0.1"))
    (run-at-time 1.5 nil #'browse-url website-preview-url)))

(defun website-publications ()
  "Refresh data/publications.json from ORCID."
  (interactive)
  (website--compile "make publications" "*website-publications*"))

(defun website-deploy ()
  "Build and upload the site."
  (interactive)
  (when (yes-or-no-p "Deploy nerovny.org? ")
    (website--compile "make deploy" "*website-deploy*")))

(defun website-open ()
  "Open the site directory."
  (interactive)
  (dired website-dir))

(defvar website-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "n") #'website-new-post)
    (define-key map (kbd "p") #'website-preview)
    (define-key map (kbd "o") #'website-open)
    (define-key map (kbd "u") #'website-publications)
    (define-key map (kbd "d") #'website-deploy)
    map)
  "Keymap for nerovny.org commands.")
(global-set-key (kbd "C-c w") website-map)

;; Spell checking for site content, in every installed site dictionary.
(defvar website-dictionaries
  (seq-filter (lambda (d) (file-exists-p (format "/usr/share/hunspell/%s.dic" d)))
              '("en_US" "ru_RU" "de_DE"))
  "Hunspell dictionaries available for the site languages.")

(defun website--spell-setup ()
  "Turn on multi-language flyspell in site buffers."
  (when (and buffer-file-name
             (executable-find "hunspell")
             website-dictionaries
             (file-in-directory-p buffer-file-name website-dir))
    (require 'ispell)
    (let ((dicts (string-join website-dictionaries ",")))
      (setq-local ispell-program-name "hunspell")
      (ispell-set-spellchecker-params)
      (ispell-hunspell-add-multi-dic dicts)
      (setq-local ispell-local-dictionary dicts))
    (flyspell-mode 1)))

(add-hook 'org-mode-hook #'website--spell-setup)
(add-hook 'markdown-mode-hook #'website--spell-setup)

(provide 'blog)
;;; blog.el ends here
