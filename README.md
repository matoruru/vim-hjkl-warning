# vim-hjkl-warning

This is a plugin which shows a warning when you move in inefficient way, in other words, movements with only or too many repeating <kbd>h</kbd> <kbd>j</kbd> <kbd>k</kbd> <kbd>l</kbd>.

![screenshot](https://github.com/matoruru/imgs/blob/master/vim-hjkl-warning/warning2.png)

This plugin can help you to notice whether you have a bad practice to move in Vim/Neovim editor. Then if you have, improve that your bad practice right now. Use <kbd>f</kbd> <kbd>F</kbd> or other searching methods to make your movements effective.

## Installation

Use your favorite plugin manager.

```vim
" Your ~/.vimrc or ~/.config/nvim/init.vim

Plug 'matoruru/vim-hjkl-warning'
```

Currently, vim-plug is the only tested for this plugin.

## Options

```vim
" Your ~/.vimrc or ~/.config/nvim/init.vim

" Change the width/height of floating window.
g:hjkl_warning_win_width    = 41
g:hjkl_warning_win_height   = 2

" Change the border to warn.
" In this case, the effective movement means to move over 4 characters in the current line or over 3 lines.
" If not, that is the inefficient way. You see a warning when you repeat it over 5 times.
g:hjkl_warning_min_column   = 4
g:hjkl_warning_min_line     = 3
g:hjkl_warning_max_repeat   = 5

" Change the warning message. It can be included multiple messages as a list.
g:hjkl_warning_message      = ["You press too many times h/j/k/l to move!"]

" Change the enable/disable warning.
g:hjkl_warning_enable       = v:true

" Change the window title and its enable/disable.
g:hjkl_warning_enable_title = v:true
g:hjkl_warning_title        = "[hjkl-warning]:"
```

## Commands

### Toogle on/off of this plugin's feature

Turn this plugin's feature on/off:

```vim
:HJKLWarningToggle
```
