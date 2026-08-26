;;; music.el --- MPD control via the built-in mpc.el -*- lexical-binding: t; -*-
;;; Commentary:
;;; Front-end for the local Music Player Daemon (see stow/mpd).
;;;
;;; `mpc' (bound to C-c m) opens a multi-pane, mouse-friendly browser: tag
;;; columns (Artist / Album / ...), the matching song list, and the current
;;; playlist.  It ships with Emacs (no external package), has a menu bar, and
;;; is mostly mouse-driven, so no "magic keys" are required.
;;;
;;; Code:

(use-package mpc
  :ensure nil            ; built-in — do NOT fetch from MELPA
  :defer t
  :commands (mpc)
  :init
  ;; Match the local-only daemon from stow/mpd/.config/mpd/mpd.conf.
  ;; `mpc-host' takes "host:port" (or a socket path).
  (setq mpc-host "127.0.0.1:6600")
  :bind (("C-c m" . mpc)))

(provide 'music)
;;; music.el ends here
