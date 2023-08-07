;;; my/projects/hm-lotto --- Class for hm-lotto project
;;; Commentary:
;;; none

;;; Code:
(dir-locals-set-class-variables
 'hm-lotto-directory
 '((nil
    .
    ((indent-tabs-mode . nil)
     (tab-width . 4) (fill-column . 80)
     ;; (add-to-list 'lsp-clients-clangd-args "--compile-commands-dir=./build" "--query-driver=/**/bin/aarch64-euler-elf-*")
     (compile-command
      .
      "export T=virt-hyp && export E=dev && source ~/dev/hm-grc-scripts/SDK/environment-setup-aarch64-euler-elf && ./src/hm-lotto/build.sh")
     (projectile-project-compilation-cmd
      .
      "export
 T=virt-hyp && export E=dev && source ~/dev/hm-grc-scripts/SDK/environment-setup-aarch64-euler-elf && ./src/hm-lotto/build.sh")))
   ;; Warn about spaces used for indentation:
   (c-mode . ((c-file-style . "bsd")))))

(dir-locals-set-directory-class
 "/home/locutus/dev/lotto" 'hm-lotto-directory)

;;; lotto.el ends here
