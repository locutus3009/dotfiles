;;;;; Startup optimizations

;;;;;; Better garbage collection strategy

;; High GC threshold during startup for faster loading
(setq gc-cons-threshold (* 100 1024 1024)) ; 100MB
(setq gc-cons-percentage 0.6)
(setq read-process-output-max (* 1024 1024)) ; 1MB for LSP/async processes

;;;;;; File name handler optimization

(defvar file-name-handler-alist-original file-name-handler-alist)
(setq file-name-handler-alist nil)

;;;;;; Reset optimizations after startup

(add-hook 'emacs-startup-hook
  (lambda ()
    ;; Restore file-name-handler-alist
    (setq file-name-handler-alist file-name-handler-alist-original)

    ;; Lower GC threshold for normal operation (16MB)
    (setq gc-cons-threshold (* 16 1024 1024))
    (setq gc-cons-percentage 0.1)

    (message "Startup optimizations reset: GC threshold lowered to 16MB")))

;;;;;; Garbage collect on idle and when losing focus

;; Run GC when idle for 5 seconds
(run-with-idle-timer 5 t #'garbage-collect)

;; Run GC when Emacs loses focus
(add-hook 'focus-out-hook #'garbage-collect)

(provide 'optimization)
