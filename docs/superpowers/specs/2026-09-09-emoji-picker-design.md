# Specification: Native Rofi Emoji Picker for Hyprland

**Date**: 2026-09-09
**Status**: Approved
**Target Directory**: `hypr/scripts/`, `rofi/`, `hypr/hyprland.lua`

## 1. Overview & Goals
Provide a fast, aesthetic, and fully integrated emoji picker for Hyprland using Rofi. The picker supports fuzzy search across Unicode emoji glyphs, names, keywords, and categories, maintains a Most Recently Used (MRU) cache for instant access, and supports both direct auto-typing and clipboard copying.

## 2. Architecture & Components

### 2.1 Component Breakdown
1. **Emoji Dataset (`rofi/data/emojis.txt`)**:
   - Comprehensive UTF-8 emoji list formatted as:
     `<emoji>\t<Name>\t<Keywords & Category>`
   - Spans all standard Unicode categories (Smileys & Emotion, People & Body, Animals & Nature, Food & Drink, Travel & Places, Activities, Objects, Symbols, Flags).
2. **Preset Styling in `hypr/scripts/rofi_menu.sh`**:
   - Extends `rofi_theme_override()` with the `emoji` preset.
   - Preset dimensions: 560px width, 9 list lines, aligned with `theme.rasi` colors (`#ff355e` accent, `#080a0dfa` dark background).
3. **Execution Script (`hypr/scripts/emoji.sh`)**:
   - Reads MRU cache from `~/.cache/rofi/emoji_recent` and prepends recent emojis to the list.
   - Launches Rofi in dmenu mode using `rofi_run emoji`.
   - Handles standard acceptance (`Enter` -> copy to `wl-copy` + auto-type via `wtype` if present, with notification fallback).
   - Handles custom exit / modifier key (`Alt+Enter` / `-kb-custom-1` -> copy only).
   - Updates `~/.cache/rofi/emoji_recent` (capped at 25 entries).
4. **Hyprland Keybinding (`hypr/hyprland.lua`)**:
   - Binds `Super + .` (`mainMod + period`) to execute `hypr/scripts/emoji.sh`.

## 3. Data Flow
1. User presses `Super + .`.
2. `emoji.sh` gathers recent items from `~/.cache/rofi/emoji_recent` and combines them with `rofi/data/emojis.txt`.
3. Rofi presents a formatted list:
   `🔥   Fire                          flame, hot, lit, burn`
4. User types fuzzy search queries (e.g. "laugh", "party", "fire", "skull") and selects an emoji.
5. `emoji.sh` extracts the raw emoji character:
   - Writes to `wl-copy`.
   - Updates the MRU cache file.
   - If `wtype` is installed, sleeps ~80ms for focus restoration and types the emoji into the active window.
   - If `wtype` is not installed or if copy-only was triggered, displays a desktop notification via `notify-send`.

## 4. Error Handling & Edge Cases
- **Missing Cache File**: If `~/.cache/rofi/emoji_recent` does not exist, initialize it cleanly.
- **Rofi Cancellation**: If user presses `Escape` or clicks outside, exit code 0 without action.
- **Missing `wtype`**: Automatically fallback to clipboard copying + toast notification without erroring.
- **Deduplication**: Prevent duplicate entries in recent history.

## 5. Verification Plan
- Launch `hypr/scripts/emoji.sh` directly in terminal to verify rofi rendering and theme consistency.
- Test fuzzy searching with common queries ("party", "heart", "smile", "rocket").
- Test selection and verify `wl-paste` output.
- Verify MRU cache updates in `~/.cache/rofi/emoji_recent`.
- Verify keybinding syntax in `hypr/hyprland.lua`.
