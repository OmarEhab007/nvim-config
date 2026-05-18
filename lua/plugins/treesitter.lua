return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      -- Install parsers
      require("nvim-treesitter.install").prefer_git = true

      -- Ensure parsers are installed
      local ensure_installed = {
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
        "markdown_inline",
        "prisma",
        "vim",
        "vimdoc",
        "query",
      }

      -- Auto-install missing parsers when entering buffer
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local parsers = require("nvim-treesitter.parsers")
          local lang = parsers.ft_to_lang(vim.bo.filetype)
          if lang and vim.tbl_contains(ensure_installed, lang) then
            local is_installed = #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".so", false) > 0
            if not is_installed then
              vim.cmd("TSInstall " .. lang)
            end
          end
        end,
      })

      -- Enable treesitter-based highlighting
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })

      -- Enable treesitter-based indentation (use Neovim's built-in)
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          -- Try the new API first, fall back gracefully
          local ok = pcall(function()
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end)
          if not ok then
            -- Fallback: just use default indentation
          end
        end,
      })
    end,
    dependencies = {
      "hiphish/rainbow-delimiters.nvim",
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
  },

  -- Textobjects - DISABLED: incompatible with new nvim-treesitter API
  -- TODO: Re-enable when nvim-treesitter-textobjects is updated
  -- See: https://github.com/nvim-treesitter/nvim-treesitter-textobjects/issues
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    enabled = false,
  },

  -- Textsubjects - DISABLED: incompatible with new nvim-treesitter API
  -- TODO: Re-enable when nvim-treesitter-textsubjects is updated
  {
    "RRethy/nvim-treesitter-textsubjects",
    enabled = false,
  },

  {
    "windwp/nvim-ts-autotag",
    event = "BufReadPre",
    config = function()
      require('nvim-ts-autotag').setup({
        opts = {
          enable_close = false,          
          enable_rename = true,          
          enable_close_on_slash = true   
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

