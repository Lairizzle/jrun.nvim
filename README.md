# jrun.nvim

A small Neovim plugin to compile and run Java files from a floating terminal.

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "lairizzle/jrun.nvim",
  config = function()
    vim.keymap.set("n", "<leader>jr", function()
      require("java_run").run()
    end, { desc = "Run Java in floating terminal" })
  end,
}
