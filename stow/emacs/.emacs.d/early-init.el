;;; early-init.el --- Runs before package.el and the first frame -*- lexical-binding: t; -*-
;;; Commentary:
;;; Everything in here has to happen BEFORE packages are activated and BEFORE
;;; the initial frame is built.  Startup GC/IO tuning, native compilation and
;;; frame geometry belong here; putting them in init.el is too late to have
;;; any effect.
;;; Code:

;;;; Startup GC and I/O tuning

;; Raise the GC ceiling for the whole init sequence, then put it back to a
;; sane working value once startup is done.
(setq gc-cons-threshold (* 100 1024 1024))
(setq gc-cons-percentage 0.6)
(setq read-process-output-max (* 1024 1024)) ; 1MB, helps LSP and async processes

;; Skip file-name handler regexp lookups while loading init files.
(defvar my/file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq file-name-handler-alist my/file-name-handler-alist)
            (setq gc-cons-threshold (* 16 1024 1024))
            (setq gc-cons-percentage 0.1)))

;;;; Native compilation (Emacs 28+)

(setq native-comp-async-report-warnings-errors nil)
;; Renamed from `native-comp-deferred-compilation' in Emacs 29.
(setq native-comp-jit-compilation t)

;;;; Frame appearance
;; Declaring these here means the bars are never built, rather than built and
;; immediately torn down from init.el.

(push '(tool-bar-lines . 0) default-frame-alist)
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(push '(internal-border-width . 22) default-frame-alist)

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(setq frame-resize-pixelwise t)       ; allow non-char-cell sizes (tiling WMs)
(setq frame-inhibit-implied-resize t) ; no auto-resize on font/fringe changes
(setq inhibit-startup-message t)

(provide 'early-init)
;;; early-init.el ends here
