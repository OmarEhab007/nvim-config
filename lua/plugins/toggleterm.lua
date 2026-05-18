return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = "BufReadPre",
    config = function()
      require 'nvim-treesitter.configs'.setup {
        ensure_installed = {
          "tsx",
          "typescript",
          "javascript",
          "html",
          "css",
          "vue",
          "astro",
          "svelte",
          "gitcommit",
          "graphql",
          "json",
          "json5",
          "lua",
          "markdown",
          "prisma",
          "vim",
          "dap_repl",
        },                              -- one of "all", or a list of languages
        sync_install = false,           -- install languages synchronously (only applied to `ensure_installed`)
        ignore_install = { "haskell" }, -- list of parsers to ignore installing
        highlight = {
          enable = true,
        },

        incremental_selection = {
          enable = false,
          keymaps = {
            init_selection    = "<leader>gnn",
            node_incremental  = "<leader>gnr",
            scope_incremental = "<leader>gne",
            node_decremental  = "<leader>gnt",
          },
        },

        indent = {
          enable = true
        },

        textobjects = {
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]]"] = "@jsx.element",
              ["]f"] = "@function.outer",
              ["]m"] = "@class.outer",
            },
            goto_next_end = {
              ["]F"] = "@function.outer",
              ["]M"] = "@class.outer",
            },
            goto_previous_start = {
              ["[["] = "@jsx.element",
              ["[f"] = "@function.outer",
              ["[m"] = "@class.outer",
            },
            goto_previous_end = {
              ["[F"] = "@function.outer",
              ["[M"] = "@class.outer",
            },
          },
          select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["~"] = "@parameter.inner",
            },
          },
        },

        textsubjects = {
          enable = true,
          prev_selection = '<BS>',
          keymaps = {
            ['<CR>'] = 'textsubjects-smart', -- works in visual mode
          }
        },

      }
    end,
    dependencies = {
      "hiphish/rainbow-delimiters.nvim",
      "JoosepAlviste/nvim-ts-context-commentstring",
      -- CRITICAL FIX: textobjects and textsubjects REMOVED from here
    },
  },

  -- MOVED: Loaded independently to depend ON treesitter
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "BufReadPre",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },

  -- MOVED: Loaded independently to depend ON treesitter
  {
    "RRethy/nvim-treesitter-textsubjects",
    event = "BufReadPre",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },

  {
    "windwp/nvim-ts-autotag",
    event = "BufReadPre",
    config = function()
      require('nvim-ts-autotag').setup({
        opts = {
          enable_close = false,          -- Auto close tags
          enable_rename = true,          -- Auto rename pairs of tags
          enable_close_on_slash = true   -- Auto close on trailing </
        },
      })
    end
  },

  {
    "wurli/contextindent.nvim",
    event = "BufReadPre", 
    opts = { pattern = "*" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
}
