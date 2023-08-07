;;; my/projects/hm-verif-kernel --- Class for HongMeng kernel directory style
;;; Commentary:
;;; none

;;; Code:
(dir-locals-set-class-variables
 'hm-verif-kernel-directory
 '((nil
    .
    ((indent-tabs-mode . t)
     (tab-width . 8) (fill-column . 80)
     (compile-command
      .
      "export T=virt-hyp && export E=dev && cd .. && ./scripts/build-hm.sh")
     (projectile-project-compilation-cmd
      .
      "export T=virt-hyp && export E=dev && cd .. && ./scripts/build-hm.sh")))
   ;; Warn about spaces used for indentation:
   (c-mode
    . ((c-file-style . "Linux") (c-c++-backend . lsp-clangd)))))

(dir-locals-set-directory-class
 "/home/locutus/dev/hm-grc-scripts/hm-verif-kernel"
 'hm-verif-kernel-directory)

;;; hm-verif-kernel.el ends here
