# dbm.nvim

![Example screenshot](dbm.png)

This plugin provides dynamic buffer window management for Neovim, inspired by
tiling window managers like [dwm](https://dwm.suckless.org). It automatically
manages buffer windows in a tiled layout with a vertically maximized, lefthand
"major" buffer window, and a stack of "minor" buffer windows on the right. The
major window contains the buffer which currently needs most attention, whereas
the stacking windows contain all other buffers. Buffer windows can be quickly
rotated between major and minor, cycled through on screen, or maximized. Buffer
windows are grouped by nine possible tabs. Each buffer window can be placed on
one or multiple tabs. These tabs act more like virtual desktops or workspaces
than they do tabs as implemented in most other applications.

## Installing

Use git or your favorite package manager, and then add this configuration to
your `init.lua`:

```lua
require('dbm').setup()
```

## Subcommands

The plugin ships one command, `:DBM` with a few subcommands:

| command                 | description                                           |
|-------------------------|-------------------------------------------------------|
|`:DBM next`              | Cycle through buffer windows                          |
|`:DBM split {target}`    | Open a new buffer window with an optional `{target}`* |
|`:DBM swap`              | Minor buffer window → major buffer window             |
|`:DBM focus`             | Maximize/Minimize major buffer window                 |
|`:DBM send  {tab_number}`| Send buffer window to `{tab_number}`                  |
|`:DBM go    {tab_number}`| Navigate to tab `{tab_number}`                        |

**Note**: the `:DBM split {target}` could be anything passed to a normal
`:split` command.

## Example configuration

If you'd like to use the plugin with the author's keybindings and settings,
add this to your `init.lua`:

```lua
require('dbm').setup()

vim.opt.hidden = false

local nmap = function(input, output, options)
  vim.api.nvim_set_keymap('n', input, output, options)
end

-- Buffer window navigation
nmap('<M-h>', '<C-w>h', {noremap = true})
nmap('<M-j>', '<C-w>j', {noremap = true})
nmap('<M-k>', '<C-w>k', {noremap = true})
nmap('<M-l>', '<C-w>l', {noremap = true})

-- Buffer window management
nmap('<M-CR>', ':DBM swap<CR>',               {noremap = true, silent = true})
nmap('<M-e>',  ':DBM split ',                 {noremap = true})
nmap('<M-f>',  ':DBM focus<CR>',              {noremap = true, silent = true})
nmap('<M-n>',  ':DBM next<CR>',               {noremap = true, silent = true})
nmap('<M-q>',  ':quit<CR>',                   {noremap = true, silent = true})
nmap('<M-t>',  ':DBM split<CR>:terminal<CR>', {noremap = true, silent = true})

-- Tab navigation
nmap('<M-1>', ':DBM go 1<CR>', {noremap = true, silent = true})
nmap('<M-2>', ':DBM go 2<CR>', {noremap = true, silent = true})
nmap('<M-3>', ':DBM go 3<CR>', {noremap = true, silent = true})
nmap('<M-4>', ':DBM go 4<CR>', {noremap = true, silent = true})
nmap('<M-5>', ':DBM go 5<CR>', {noremap = true, silent = true})
nmap('<M-6>', ':DBM go 6<CR>', {noremap = true, silent = true})
nmap('<M-7>', ':DBM go 7<CR>', {noremap = true, silent = true})
nmap('<M-8>', ':DBM go 8<CR>', {noremap = true, silent = true})
nmap('<M-9>', ':DBM go 9<CR>', {noremap = true, silent = true})

-- Tab management
nmap('<M-m>1', ':DBM send 1<CR>', {noremap = true, silent = true})
nmap('<M-m>2', ':DBM send 2<CR>', {noremap = true, silent = true})
nmap('<M-m>3', ':DBM send 3<CR>', {noremap = true, silent = true})
nmap('<M-m>4', ':DBM send 4<CR>', {noremap = true, silent = true})
nmap('<M-m>5', ':DBM send 5<CR>', {noremap = true, silent = true})
nmap('<M-m>6', ':DBM send 6<CR>', {noremap = true, silent = true})
nmap('<M-m>7', ':DBM send 7<CR>', {noremap = true, silent = true})
nmap('<M-m>8', ':DBM send 8<CR>', {noremap = true, silent = true})
nmap('<M-m>9', ':DBM send 9<CR>', {noremap = true, silent = true})

-- Status and Tab lines
require('lualine').setup {
  options = {
    globalstatus = true,
    require'lualine'.setup({
      sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {{'filename', path = 1}},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
      },
      tabline = {
        lualine_a = {'tabs'},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {'buffers'}
      }
    })
  }
}
```

