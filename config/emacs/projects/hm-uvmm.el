;;; my/projects/hm-uvmm --- Class for hm-uvmm project
;;; Commentary:
;;; none

;;; Code:
(dir-locals-set-class-variables 'hm-uvmm-directory '((nil . ((indent-tabs-mode . t)
                                                             (tab-width . 8)
                                                             (fill-column . 80)
                                                             (compile-command .
                                                                              "export T=virt-hyp && export E=dev && cd .. && ./scripts/build-uvmm.sh")
                                                             (projectile-project-compilation-cmd .
                                                                                                 "export T=virt-hyp && export E=dev && cd .. && ./scripts/build-uvmm.sh")))
                                                     ;; Warn about spaces used for indentation:
                                                     (c-mode . ((c-file-style . "Linux")))))

(dir-locals-set-directory-class "/home/locutus/dev/hm-grc-scripts/hm-uvmm" 'hm-uvmm-directory)

;;; hm-uvmm.el ends here
