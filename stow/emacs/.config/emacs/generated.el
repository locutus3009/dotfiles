;; -*- lexical-binding: t; -*-
;; Palette originally produced by matugen.  The generator is no longer part
;; of this repo, so treat this file as hand-maintained until it is restored.
(defun apply-matugen-colors-to-frame (frame)
  "Apply colors appropriate for FRAME type"
  (with-selected-frame frame
    (if (display-graphic-p frame)
        ;; GUI frame - use matugen colors INCLUDING backgrounds
        ;; Note: internal-border-width is set in main.el default-frame-alist to avoid tiling issues
        (progn
          (set-frame-parameter frame 'background-color "#131318")
          (set-face-attribute 'default frame
                              :background "#131318"
                              :foreground "#e5e1e9")
          (set-face-attribute 'fringe frame
                              :background "#131318")
          (set-face-attribute 'cursor frame
                              :background "#c6bfff")
          (set-face-attribute 'mode-line frame
                              :background "#2a292f"
                              :foreground "#e5e1e9")
          (set-face-attribute 'mode-line-inactive frame
                              :background "#2a292f"
                              :foreground "#e5e1e9")
          (set-face-attribute 'region frame
                              :background "#454077")
          (set-face-attribute 'hl-line frame
                              :background "#35343a")
          (set-face-attribute 'window-divider frame
                              :foreground "#928f99")
          (set-face-attribute 'vertical-border frame
                              :foreground "#928f99"))

      ;; Terminal frame - CLEAR frame background parameter
      (progn
        (set-frame-parameter frame 'background-color nil)
        (set-face-attribute 'default frame
                            :foreground "#e5e1e9")
        (set-face-attribute 'cursor frame
                            :background "#c6bfff")
        (set-face-attribute 'mode-line frame
                            :foreground "#e5e1e9")
        (set-face-attribute 'mode-line-inactive frame
                            :foreground "#e5e1e9")
        (set-face-attribute 'window-divider frame
                            :foreground "#928f99")
        (set-face-attribute 'vertical-border frame
                            :foreground "#928f99")))))

(defun matugen-clear-tty-background ()
  "Keep TTY frames transparent to the terminal's own background.
Cheap guard: this runs on every window configuration change, so it only
touches the selected frame and only when there is something to clear."
  (let ((frame (selected-frame)))
    (when (and (not (display-graphic-p frame))
               (frame-parameter frame 'background-color))
      (set-frame-parameter frame 'background-color nil))))

(defun apply-matugen-colors ()
  "Apply material you colors to Emacs.
Call this *after* `load-theme', not before -- see theme.el."
  (mapc #'apply-matugen-colors-to-frame (frame-list))
  (add-hook 'after-make-frame-functions #'apply-matugen-colors-to-frame)
  (add-hook 'window-configuration-change-hook #'matugen-clear-tty-background))

(provide 'matugen-colors)
