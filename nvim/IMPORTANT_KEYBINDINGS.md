# ⌨️ Important Neovim Keybindings

This document lists the essential keybindings configured in this Neovim setup, excluding basic Vim motions.

## 🛠️ General / Core
| Key | Action |
| --- | --- |
| `ss` | **Save** the current file |
| `<C-x>` | **Close** current buffer or window |
| `<leader>/` | **Toggle Comment** (Line or Selection) |
| `<Esc>` | **Dismiss** notifications (Noice), clear highlights, and stop snippets |
| `<leader>e` | Toggle **File Explorer** |

## 🔍 Search & Navigation
| Key | Action |
| --- | --- |
| `<leader>ff` | **Find Files** (Telescope) |
| `<leader>fr` | **Recent Files** |
| `<leader>sg` | **Live Grep** (Search text in project) |
| `<leader>sw` | **Search Word** under cursor |
| `<leader>bb` | **Switch Buffers** |
| `[b` / `]b` | Go to **Previous / Next Buffer** |

## 🛠️ UI Toggles
| Key | Action |
| --- | --- |
| `<leader>um` | **Toggle Render Markdown** |
| `<leader>un` | **Toggle Line Numbers** |
| `<leader>ud` | **Toggle Diagnostics** |
| `<leader>uh` | **Toggle Inlay Hints** |

## 💻 LSP (Coding & Diagnostics)
| Key | Action |
| --- | --- |
| `gd` | **Go to Definition** |
| `gr` | **Go to References** |
| `K` | **Hover** Information (Documentation) |
| `<leader>ca` | **Code Actions** (Fixes, Refactors) |
| `<leader>cr` | **Rename** Symbol |
| `<leader>lf` | **Format** Buffer |
| `<leader>lj` | **Next Diagnostic** (Error/Warning) |
| `<leader>lk` | **Previous Diagnostic** |
| `<leader>lv` | **View Line Diagnostic** (Floating Window) |

## 🖥️ Terminal
| Key | Action |
| --- | --- |
| `<C-t>` | **Toggle Terminal** (Floating) |
| `<Esc><Esc>` | **Normal Mode** inside terminal |

## 🎨 Diagrams (Venn Mode)
| Key | Action |
| --- | --- |
| `<leader>uV` | **Toggle Venn Mode** (Draw ASCII diagrams) |
| `Arrow Keys` | Draw lines (while Venn mode is enabled) |
| `<Enter>` | **Add Box** (Visual mode, Venn mode only) |

---
*Note: `<leader>` is mapped to `<Space>` by default.*
