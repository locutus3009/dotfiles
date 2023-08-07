;;; my/projects/dummy --- Class for dummy project
;;; Commentary:
;;; none

;;; Code:
(dir-locals-set-class-variables 'dummy-directory '((nil . ((indent-tabs-mode . nil) 
							   (tab-width . 4) 
							   (fill-column . 80)
                                                           (compile-command . "cmd") 
							   (projectile-project-compilation-cmd .
											       "cmd")))
                                                   ;; Warn about spaces used for indentation:
                                                   (c-mode . ((c-file-style . "bsd")))))

(dir-locals-set-directory-class "/home/locutus/dev/dummy" 'dummy-directory)

;;; lotto.el ends here
