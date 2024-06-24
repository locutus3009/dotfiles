;;; my/projects/linux --- Class for Linux kernel directory style
;;; Commentary:
;;; none

;;; Code:
(dir-locals-set-class-variables
 'linux-directory
 '((nil
    .
    ((indent-tabs-mode . t)
     (tab-width . 8) (fill-column . 80)
     (compile-command
      .
      "~/apps/bin/build_linux.sh")
     (projectile-project-compilation-cmd
      .
      "~/apps/bin/build_linux.sh")))
   ;; Warn about spaces used for indentation:
   (c-mode
    . ((c-file-style . "Linux") (c-c++-backend . lsp-clangd)))))

(dir-locals-set-directory-class
 "/home/locutus/dev/linux"
 'linux-directory)
