;;; my/projects/hm-grc-scripts --- Class for hm-grc-scripts repo
;;; Commentary:
;;; none

;;; Code:
(dir-locals-set-class-variables 'hm-grc-scripts-directory '((nil . ((indent-tabs-mode . t)
                                                                    (tab-width . 8)
                                                                    (fill-column . 80)
                                                                    (projectile-project-run-cmd .
                                                                                                "export T=virt-hyp && export E=dev && export VM_IMAGE=/home/locutus/dev/hm-grc-scripts/files/linux_virt.img && export IMAGE_ROOTFS_MANIFEST=/home/locutus/dev/lotto//src/hm-lotto/lotto.manifest && ./scripts/run-hm.sh")
                                                                    (compile-command .
                                                                                     "export T=virt-hyp && export E=dev && export VM_IMAGE=/home/locutus/dev/hm-grc-scripts/files/linux_virt.img && export IMAGE_ROOTFS_MANIFEST=/home/locutus/dev/lotto//src/hm-lotto/lotto.manifest && ./scripts/build-uvmm.sh && source ~/dev/hm-grc-scripts/SDK/environment-setup-aarch64-euler-elf && ~/dev/lotto/src/hm-lotto/build.sh && ./scripts/build-hm.sh")
                                                                    (projectile-project-compilation-cmd
                                                                     .
                                                                     "export T=virt-hyp && export E=dev && export VM_IMAGE=/home/locutus/dev/hm-grc-scripts/files/linux_virt.img && export IMAGE_ROOTFS_MANIFEST=/home/locutus/dev/lotto//src/hm-lotto/lotto.manifest && ./scripts/build-uvmm.sh && source ~/dev/hm-grc-scripts/SDK/environment-setup-aarch64-euler-elf && ~/dev/lotto/src/hm-lotto/build.sh && ./scripts/build-hm.sh")))
                                                            ;; Warn about spaces used for indentation:
                                                            (c-mode . ((c-file-style . "Linux")
                                                                       (c-c++-backend .
                                                                                      lsp-clangd)))))

(dir-locals-set-directory-class "/home/locutus/dev/hm-grc-scripts" 'hm-grc-scripts-directory)

;;; hm-grc-scripts.el ends here
