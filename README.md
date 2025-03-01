# cmp-go-pkgs

[nvim-cmp](https://github.com/hrsh7th/nvim-cmp) source providing the names of **Go** packages to import

https://github.com/user-attachments/assets/10058da8-d2b0-477e-bf15-ae14dbe6e11b

## ✨ Features

- Using [gopls](https://pkg.go.dev/golang.org/x/tools/gopls) Language Server to get a list of packages available for import
- Using [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter/) to show suggestions only if the cursor is in the `import` section
- Smart suggestions. See [completion rules](#completion-rules) bellow

## 📦 Installation

Install the plugin with your preferred package manager:

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "hrsh7th/nvim-cmp",

  dependencies = {
    "Yu-Leo/cmp-go-pkgs",
  },

  config = function()
    local cmp = require("cmp")
    cmp.setup({
      sources = {
        { name = "go_pkgs" },
      },
    })
  end,
}
```

## ⚡️ Requirements

- LSP with the [gopls](https://pkg.go.dev/golang.org/x/tools/gopls) Language Server
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter/) with the `go` parser installed

## ⚙️ Setup

**⚠️ Attention! The plugin won't work without it ⚠️**

You need to add the following code next to other autocmds in your neovim config. 

```lua
vim.api.nvim_create_autocmd({ "LspAttach" }, {
  pattern = { "*.go" },
  callback = function(args)
    require("cmp_go_pkgs").init_items(args)
  end,
})
```

This code defines the following behavior: at each `LspAttach` event, the plugin will request a list of packages available for import from `gopls` and save them to its cache. This is more efficient than sending requests to the LSP for each completion request. However, because of this, if you change or add new packages, they will be displayed in the previously opened buffer only if you reopen it or call `:LspRestart`.

## 🚀 Usage

Like any other nvim-cmp source.

### Completion rules

- Complements only the package name. Without double quotes
- If the current line contains `/`, it offers only those options that contain the incomplete line as a prefix
- If the current line does not contain `/`, it offers all available options

See [my neovim configuration](https://github.com/Yu-Leo/nvim).

## 🤝 Contributing

PRs and Issues are always welcome.

Author: [@Yu-Leo](https://github.com/Yu-Leo)

## 🫶 Alternatives

### [Snikimonkd/cmp-go-pkgs](https://github.com/Snikimonkd/cmp-go-pkgs)

I took the code of this plugin as a basis and modified it to suit my needs.

