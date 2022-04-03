# dbm.nvim

![Example screenshot](dbm.png)

This plugin provides dynamic buffer management for Neovim, inspired by tiling
window managers like [dwm](https://dwm.suckless.org). It automatically manages
buffers in a tiled layout with a vertically maximized, lefthand "major" buffer,
and a stack of "minor" buffers on the right. The major area contains the buffer
which currently needs most attention, whereas the stacking area contains all
other buffers. Buffers can be quickly rotated between major and minor, cycled
through on screen, or maximized. Buffers are grouped by nine possible tabs.
Each buffer can be tagged with one or multiple tabs. These tabs act more like
virtual desktops or workspaces than they do tabs as implemented in most other
applications.

# Installing

Use git or your favorite package manager, and then add this configuration to
your `init.lua`:

```lua
require('dbm').setup()
```

## Commands

| command                | description                    |
|------------------------|--------------------------------|
|`:DBMNextBuffer`        | Cycle through buffers          |
|`:DBMSplitBuffer`       | Open a new buffer              |
|`:DBMSwapBuffer`        | Minor buffer → major buffer    |
|`:DBMToggleFocusBuffer` | Maximize/Minimize major buffer |
|`:DBMMoveToTab`         | Send buffer to tab _n_         |
|`:DBMViewTab`           | Navigate to tab _n_            |

## Example configuration

If you'd like to use the plugin with the author's keybindings and settings,
you can enable one or both:

```lua
require('dbm').setup({
  use_example_keybindings = true,
  use_example_settings    = true
})
```

