(use-package
 ranger
 :ensure t
 :config
 ;; Set ranger default handler
 (setq ranger-override-dired t)
 (setq helm-descbinds-window-style 'same-window)

 ;; to kill the buffers that were opened while browsing the directories.
 ;; (setq ranger-cleanup-on-disable t)
 ;; to kill the buffer just after you move to another entry in the dired buffer.
 (setq ranger-cleanup-eagerly t)

 ;; to show dotfiles at ranger startup, toggled by zh.
 (setq ranger-show-dotfiles t)

 ;;;;;;
 ;; Parent Window Options
 ;;;;;;

 ;; set the number of folders to nest to the left, adjusted by z- and z+.
 (setq ranger-parent-depth 1)

 ;; set the size of the parent windows as a fraction of the frame size.
 (setq ranger-width-parents 0.22)

 ;;;;;;
 ;; Preview Window Options
 ;;;;;;

 ;; set the default preference to preview selected file.
 (setq ranger-preview-file nil)

 ;; set the max files size (in MB)
 (setq ranger-max-preview-size 10)

 ;; to determine if the file selected is a binary file
 (setq ranger-dont-show-binary t))
