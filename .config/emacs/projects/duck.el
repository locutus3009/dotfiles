;;; my/projects/duck --- Class for duck project
;;; Commentary:
;;; none

;;; Code:
(dir-locals-set-class-variables 'duck-directory '((nil . ((indent-tabs-mode . nil) 
							  (tab-width . 4) 
							  (fill-column . 80)
							  ;; (add-to-list 'lsp-clients-clangd-args "--compile-commands-dir=./build" "--query-driver=/**/bin/aarch64-euler-elf-*")
							  (projectile-project-configure-cmd .
											    ". ~/.cargo/env && cmake -G Ninja -Bbuild --toolchain scripts/toolchain/clang-aarch64-linux-gnu.cmake -DWARNS_AS_ERRORS=False -DBOARD=BOARD_RPI4B")
(projectile-project-compilation-cmd . ". ~/.cargo/env && cmake --build build/")))
                                                  ;; Warn about spaces used for indentation:
                                                  (c-mode . ((c-file-style . "bsd")))))

(dir-locals-set-directory-class "/home/locutus/dev/duck" 'duck-directory)

;;; duck.el ends here
