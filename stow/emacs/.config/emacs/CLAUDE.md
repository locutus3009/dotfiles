# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a modular Emacs configuration stored in `~/.config/emacs/` and loaded via `~/.emacs.d/init.el`. The configuration is split into focused modules loaded in a specific order, optimized for performance with GTD-style org-mode workflow, LSP development, and modern Emacs features.

## Configuration Architecture

### Load Order (Critical)
Files are loaded in this specific order from `~/.emacs.d/init.el`:

1. **main.el** - Package management, native compilation, core settings (MUST load first)
2. **theme.el** - Spacemacs-dark theme, doom-modeline, visual enhancements
3. **completion.el** - Ivy/Counsel, Company, smex
4. **projects.el** - Magit, Forge, Projectile, project-specific configs
5. **edit.el** - Multiple cursors, iedit, markdown, avy, helpful, undo-tree
6. **prog.el** - LSP, language modes (Rust, C/C++, Lua, YAML), flycheck, yasnippet
7. **orgconf.el** - Extensive org-mode GTD setup (largest file, ~870 lines)
8. **keys.el** - Custom keybindings
9. **dired.el** - Dired-sidebar file browsing
10. **optimization.el** - GC strategy, startup optimizations (MUST load late)
11. **dashboard.el** - Startup dashboard

### Module Responsibilities

**main.el** - Foundation layer:
- Native compilation settings (Emacs 28+)
- Tiling WM compatibility (frame-resize-pixelwise, frame-inhibit-implied-resize)
- Package archives: GNU, MELPA, Org
- use-package bootstrap
- Pinentry GPG integration
- w3m symbol configuration
- Custom file handling (`~/.emacs.d/custom.el`)

**orgconf.el** - Complex GTD workflow:
- Custom TODO keywords: TODO → NEXT → IN_REVIEW → DONE, plus WAITING/HOLD/CANCELLED
- 8 capture templates (todo, meeting, journal, habit, etc.)
- Org-babel (emacs-lisp, shell, python)
- Clock tracking with automatic task switching (`bh/clock-in-to-next`)
- Refile optimized for Ivy/Counsel (file paths, single-step completion)
- Custom agenda views (Notes, Habits, Events, master "m" view)
- GTD helper functions: `bh/is-project-p`, `bh/is-task-p`, skip functions
- Org-modern for visual enhancement
- Effort tracking and habit display
- Organization task ID: `eb155a82-92b2-4f25-a3c6-0304591af2f9`

**projects.el** - Project-specific configurations:
- Loads `projects/linux.el` and `projects/dummy.el`
- Each defines `dir-locals-set-class-variables` and `dir-locals-set-directory-class`
- Linux kernel style: tabs, 8-space width, `build_linux.sh` script
- Supports project-local compilation commands

**prog.el** - Language tooling:
- LSP performance optimized: file watchers disabled, no breadcrumb, company completion
- Rust: rustic-mode with rust-analyzer hints
- C/C++: clang-format with auto-detection from `.clang-format`
- Lua: custom formatter function `format-lua-buffer`
- ggtags for navigation (C, C++, Java, Python, Lisp)

**optimization.el** - Performance critical:
- Startup: 100MB GC threshold, file-name-handler-alist disabled
- Post-startup: Reset to 16MB GC, restore file handlers
- Idle GC every 5 seconds + on focus-out

## Key Configuration Patterns

### Adding Packages
Always use `use-package` with `:ensure t` and `:defer t` when possible:
```elisp
(use-package package-name
  :ensure t
  :defer t
  :bind (("key" . function))
  :config
  ;; configuration here
  )
```

### Project-Specific Settings
Create new file in `projects/` directory:
```elisp
(dir-locals-set-class-variables
 'project-name-directory
 '((nil . ((indent-tabs-mode . nil)
           (compile-command . "make")))))

(dir-locals-set-directory-class
 "/path/to/project" 'project-name-directory)
```
Then add `(load-file "~/.config/emacs/projects/project-name.el")` to projects.el

### Org-Mode Customization
- Agenda files: `~/ORG/` directory (uses directory, not wildcards for performance)
- Refile targets: Max level 9 in current file and all agenda files
- Capture templates: Add to `org-capture-templates` in orgconf.el
- GTD functions follow `bh/` prefix convention (from Bernt Hansen's workflow)

## Performance Considerations

**Critical Settings:**
- Native compilation enabled (Emacs 30.2)
- `org-agenda-inhibit-startup t` (major speedup)
- `org-element-cache-persistent t`
- LSP file watchers disabled
- Package archives: Only GNU, MELPA, Org (removed marmalade, SC)

**Do NOT:**
- Add `package-initialize` calls (already in main.el)
- Enable org-agenda-follow-mode by default (very slow, toggle with 'F')
- Use wildcard expansion for `org-agenda-files`
- Enable package-quickstart (removed per user preference)

## Tiling WM Compatibility (Polonium/KDE)

Emacs uses pgtk (Pure GTK) backend on Wayland. Critical settings in main.el prevent frame resize issues with tiling WMs:

```elisp
(setq frame-resize-pixelwise t)        ; Accept any pixel size from WM
(setq frame-inhibit-implied-resize t)  ; Don't auto-resize on font/fringe changes
(setq default-frame-alist '((internal-border-width . 22)))
```

**Why these matter:**
- Without `frame-inhibit-implied-resize`, Emacs requests frame resizes after startup when fonts/fringes load
- Polonium (KWin tiling script) interprets resize requests as "window wants to float"
- `internal-border-width` must be in `default-frame-alist` (set at frame creation), NOT via `set-frame-parameter` (which triggers resize)

**Matugen integration:**
- `generated.el` is created by matugen from template at `~/.config/matugen/templates/emacs/colors.el`
- Template must NOT set `internal-border-width` dynamically (causes tiling issues)
- Colors are reapplied after theme load via advice on `load-theme`

## Critical Dependencies

**External tools required:**
- `clangd` for C/C++ LSP
- `rust-analyzer` for Rust
- `lua-format` for Lua formatting
- `gpg-agent` for pinentry
- Nerd fonts for icons (run `M-x nerd-icons-install-fonts`)

**Org-mode files expected:**
- `~/ORG/refile.org` (default capture target)
- `~/ORG/journal.org` (journal entries)
- `~/ORG/habits.org` (habit tracking)

## Common Modification Scenarios

**Adding a new language:**
1. Add use-package to prog.el with `:defer t`
2. Configure LSP if applicable (add to lsp-mode :hook)
3. Add to ggtags hooks if needed for navigation

**Modifying GTD workflow:**
1. Edit orgconf.el (search for relevant section)
2. Test with `M-x org-agenda` before committing
3. Check `bh/` helper functions for side effects

**Performance issues:**
1. Check optimization.el GC settings
2. Verify LSP performance flags in prog.el
3. Profile with `M-x profiler-start` / `profiler-report`

**Package installation fails:**
1. `M-x package-refresh-contents`
2. Check package-archives in main.el
3. Verify network access to HTTPS archives

## Keybindings Philosophy

- Arrow keys disabled (forces Emacs native movement)
- Mouse buttons 2-3 disabled
- Org-mode: Standard `C-c` prefix for org commands
- Window movement: `C-x p/n` (up/down), `C-x ,/.` (left/right)
- Avy: `C-'` (char jump), `C-:` (line jump)
- Helpful: Replaces default `C-h f/v/k/x`

## File Locations

- Main config: `~/.config/emacs/*.el`
- Init file: `~/.emacs.d/init.el` (just loads config files)
- Custom settings: `~/.emacs.d/custom.el` (auto-generated)
- Org files: `~/ORG/`
- Undo history: `~/.emacs.d/undo-tree-history/`
- Org-ID cache: `~/.emacs.d/.org-id-locations`
- Backups: `~/.emacs.d/backup/`

## Testing Changes

After modifications:
1. Check syntax: `emacs --batch --eval "(byte-compile-file \"file.el\")"`
2. Test load: Start fresh Emacs instance
3. Check *Messages* buffer for errors
4. For org-mode: Test with `M-x org-agenda` and sample capture
5. For LSP: Open a project file and verify `M-x lsp` works

## Anti-Patterns to Avoid

- Do not add configuration outside use-package blocks (breaks lazy loading)
- Do not use `require` for packages (use `:after` in use-package)
- Do not modify load order without understanding dependencies
- Do not add `custom-set-variables` manually (use `M-x customize`)
- Do not create tight coupling between modules
- Do not use `set-frame-parameter` for size-related properties (use `default-frame-alist` instead - see Tiling WM section)
