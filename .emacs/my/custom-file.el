(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("7fd8b914e340283c189980cd1883dbdef67080ad1a3a9cc3df864ca53bdc89cf" default))
 '(package-selected-packages
   '(treemacs-tab-bar treemacs-persp treemacs-magit treemacs-icons-dired treemacs-projectile treemacs-evil treemacs smex page-break-lines dashboard all-the-icons-ivy-rich all-the-icons-ivy gitlab elisp-format multiple-cursors counsel-projectile counsel ivy auto-dim-other-buffers helm smartparens paredit mu4e use-package sublime-themes spacemacs-theme org-journal magit company))
 '(safe-local-variable-values
   '((c-c++-backend . lsp-clangd)
     (projectile-project-compilation-cmd . "export
 T=virt-hyp && export E=dev && source ~/dev/hm-grc-scripts/SDK/environment-setup-aarch64-euler-elf && ./src/hm-lotto/build.sh")
     (projectile-project-compilation-cmd . "export T=virt-hyp && export E=dev && cd .. && ./scripts/build-uvmm.sh")
     (projectile-project-compilation-cmd . "export T=virt-hyp && export E=dev && export VM_IMAGE=/home/locutus/dev/hm-grc-scripts/files/linux_virt.img && export IMAGE_ROOTFS_MANIFEST=/home/locutus/dev/lotto//src/hm-lotto/lotto.manifest && ./scripts/build-uvmm.sh && source ~/dev/hm-grc-scripts/SDK/environment-setup-aarch64-euler-elf && ~/dev/lotto/src/hm-lotto/build.sh && ./scripts/build-hm.sh")
     (projectile-project-run-cmd . "export T=virt-hyp && export E=dev && export VM_IMAGE=/home/locutus/dev/hm-grc-scripts/files/linux_virt.img && export IMAGE_ROOTFS_MANIFEST=/home/locutus/dev/lotto//src/hm-lotto/lotto.manifest && ./scripts/run-hm.sh")
     (projectile-project-compilation-cmd . "export T=virt-hyp && export E=dev && cd .. && ./scripts/build-hm.sh"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background nil)))))
