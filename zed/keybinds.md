# Zed Keybindings

## Normal Mode — File Picker & Projects
**Context:** `vim_mode == normal && (Workspace || Editor || EmptyPane)`

| Key | Action |
|---|---|
| `space f f` | `file_finder::Toggle` |
| `space f p` | `projects::OpenRecent` |

## Normal Mode — Terminal, File Tree & Close
**Context:** `(Workspace || Editor) && vim_mode == normal`

| Key | Action |
|---|---|
| `alt-f` | `project_panel::ToggleFocus` |
| `space f e` | `project_panel::ToggleFocus` |
| `space t t` | `terminal_panel::ToggleFocus` |
| `space q` | `pane::CloseActiveItem` |

## Normal Mode — Editor
**Context:** `Editor && vim_mode == normal && !VimWaiting && !menu`

### Pane Navigation
| Key | Action |
|---|---|
| `ctrl-h` | `workspace::ActivatePaneLeft` |
| `ctrl-l` | `workspace::ActivatePaneRight` |
| `ctrl-k` | `workspace::ActivatePaneUp` |
| `ctrl-j` | `workspace::ActivatePaneDown` |

### LSP
| Key | Action |
|---|---|
| `space c a` / `space .` | `editor::ToggleCodeActions` |
| `space c r` | `editor::Rename` |
| `space c f` | `buffer_search::DeployReplace` |
| `g d` | `editor::GoToDefinition` |
| `g D` | `editor::GoToDefinitionSplit` |
| `g i` | `editor::GoToImplementation` |
| `g I` | `editor::GoToImplementationSplit` |
| `g t` | `editor::GoToTypeDefinition` |
| `g T` | `editor::GoToTypeDefinitionSplit` |
| `g r` | `editor::FindAllReferences` |
| `] d` | `editor::GoToDiagnostic` |
| `[ d` | `editor::GoToPreviousDiagnostic` |
| `s s` | `outline::Toggle` |
| `s S` | `project_symbols::Toggle` |
| `space x x` | `diagnostics::Deploy` |

### Close
| Key | Action |
|---|---|
| `space q` | `pane::CloseActiveItem` |
| `shift-q` | `pane::CloseAllItems` |
| `ctrl-q` | `pane::CloseActiveItem` |

### Buffer Navigation
| Key | Action |
|---|---|
| `shift-j` | `pane::ActivatePreviousItem` |
| `shift-h` | `pane::ActivatePreviousItem` |
| `shift-k` | `pane::ActivateNextItem` |
| `shift-l` | `pane::ActivateNextItem` |
| `space /` | `pane::DeploySearch` |
| `space e` | `pane::RevealInProjectPanel` |
| `ctrl-s` | `workspace::Save` |

### Tab
| Key | Action |
|---|---|
| `space t n` | `workspace::NewFile` |

### Editing
| Key | Action |
|---|---|
| `alt-shift-up` | `editor::DuplicateLineUp` |
| `alt-shift-down` | `editor::DuplicateLineDown` |
| `ctrl-a` | `editor::SelectAll` |

## Normal Mode — Hover, Splits & Scroll
**Context:** `Editor && vim_mode == normal`

| Key | Action |
|---|---|
| `K` | `editor::Hover` |
| `ctrl-w v` | `pane::SplitRight` |
| `ctrl-w s` | `pane::SplitDown` |
| `z z` | `editor::ScrollCursorCenter` |
| `z t` | `editor::ScrollCursorTop` |
| `z b` | `editor::ScrollCursorBottom` |

## Normal Mode — Misc
**Context:** `vim_mode == normal`

| Key | Action |
|---|---|
| `g o` | `vim::StartOfDocument` |

## Normal Mode — Window Navigation
**Context:** `(Terminal || Dock || Workspace || Editor)`

| Key | Action |
|---|---|
| `ctrl-w h` | `workspace::ActivatePaneLeft` |
| `ctrl-w l` | `workspace::ActivatePaneRight` |
| `ctrl-w k` | `workspace::ActivatePaneUp` |
| `ctrl-w j` | `workspace::ActivatePaneDown` |

## Visual Mode — Comments & Move
**Context:** `Editor && vim_mode == visual && !VimWaiting && !menu`

| Key | Action |
|---|---|
| `g c` | `editor::ToggleComments` |

**Context:** `vim_mode == visual`

| Key | Action |
|---|---|
| `shift-j` | `editor::MoveLineDown` |
| `shift-k` | `editor::MoveLineUp` |

## Insert Mode
**Context:** `Editor && vim_mode == insert`

| Key | Action |
|---|---|
| `j j` | `vim::NormalBefore` |
| `j k` | `vim::NormalBefore` |

## Operator-pending Mode
**Context:** `Editor && vim_operator == c`

| Key | Action |
|---|---|
| `c` | `vim::CurrentLine` |
| `r` | `editor::Rename` |

## Dock
**Context:** `Workspace`

| Key | Action |
|---|---|
| `alt-f` | `workspace::ToggleLeftDock` |
| `alt-a` | `workspace::ToggleRightDock` |
