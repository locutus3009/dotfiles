(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("7f1d414afda803f3244c6fb4c2c64bea44dac040ed3731ec9d75275b9e831fe5" "57a29645c35ae5ce1660d5987d3da5869b048477a7801ce7ab57bfb25ce12d3e" "833ddce3314a4e28411edf3c6efde468f6f2616fc31e17a62587d6a9255f4633" "d89e15a34261019eec9072575d8a924185c27d3da64899905f8548cbd9491a36" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "9b59e147dbbde5e638ea1cde5ec0a358d5f269d27bd2b893a0947c4a867e14c1" "7fd8b914e340283c189980cd1883dbdef67080ad1a3a9cc3df864ca53bdc89cf" default))
 '(package-selected-packages
   '(nerd-icons doom-themes solarized solarized-dark smart-mode-line doom-modeline spacebar clang-format flycheck which-key dap-c++ lsp-ivy lsp-ui lsp-mode treemacs-tab-bar treemacs-persp treemacs-magit treemacs-icons-dired treemacs-projectile smex page-break-lines dashboard all-the-icons-ivy-rich all-the-icons-ivy elisp-format multiple-cursors counsel-projectile counsel ivy auto-dim-other-buffers smartparens paredit mu4e use-package org-journal magit company))
 '(safe-local-variable-values
   '((add-to-list 'lsp-clients-clangd-args "--compile-commands-dir=./build" "--query-driver=/**/bin/aarch64-euler-elf-*")
     (setq lsp-clients-clangd-args
	   '("--compile-commands-dir=./build" "--query-driver=/**/bin/aarch64-euler-elf-*"))
     (c-c++-backend . lsp-clangd)
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
