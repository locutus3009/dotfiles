;; -*- lexical-binding: t; -*-
;;; my/projects/vulkan --- vulkan GPU memory model verification
;;; Code:
(dir-locals-set-class-variables
 'vulkan-directory
 '((nil
    . ((projectile-project-compilation-dir . "../build.native")
       (projectile-project-compilation-cmd . "cmake --build .")
       (projectile-project-test-cmd . "cmake --build . --target test")
       (projectile-project-configure-cmd
        . "cmake -S . -B ../build.native -G Ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=ON")))
   (c++-mode
    . ((c-c++-backend . lsp-clangd)
       (lsp-clients-clangd-args . ("--compile-commands-dir=../build.native"))))))
(dir-locals-set-directory-class
 "/home/locutus/dev/huawei-drc/work/gpu-verification"
 'vulkan-directory)
