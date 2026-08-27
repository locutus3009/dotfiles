;; -*- lexical-binding: t; -*-
;;; my/projects/vulkan --- vulkan GPU memory model verification
;;; Code:
(dir-locals-set-class-variables
 'vulkan-directory
 '((nil
    . ((projectile-project-compilation-dir . "build")
       (projectile-project-compilation-cmd . "cmake --build .")
       (projectile-project-configure-cmd
        . "cmake -S ../ -B . -G Ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=ON")))
   (c++-mode
    . ((c-c++-backend . lsp-clangd)))
   (c++-ts-mode
    . ((c-c++-backend . lsp-clangd)))))
(dir-locals-set-directory-class
 "/hdd/locutus/dev/huawei-drc/work/gpu-verification"
 'vulkan-directory)
