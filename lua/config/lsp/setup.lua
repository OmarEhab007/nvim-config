-- Setup installer & lsp configs
local mason = require("mason")
local mason_lsp = require("mason-lspconfig")
local ufo_utils = require("utils._ufo")
local ufo_config_handler = ufo_utils.handler
local lspconfig = require("lspconfig")

-- 1. Setup Mason
mason.setup({
  ui = {
    border = LeerVim.ui.float.border or "rounded",
  },
})

-- 2. Define Capabilities, Handlers, and OnAttach FIRST (so they are available below)
-- Local replacement for vim.lsp.with(), which was removed in Nvim 0.12.
-- Same behavior: returns a handler that merges the override config.
local function with(handler, override_config)
  return function(err, result, ctx, config)
    return handler(err, result, ctx, vim.tbl_deep_extend("force", config or {}, override_config))
  end
end

local handlers = {
  ["textDocument/hover"] = with(vim.lsp.handlers.hover, {
    silent = true,
    border = LeerVim.ui.float.border,
  }),
  ["textDocument/signatureHelp"] = with(vim.lsp.handlers.signature_help, { border = LeerVim.ui.float.border }),
}

local capabilities = require('blink.cmp').get_lsp_capabilities()

local function on_attach(client, bufnr)
  vim.lsp.inlay_hint.enable(true, { bufnr })
end

-- Global override for floating preview border
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or LeerVim.ui.float.border or "rounded" -- default to LeerVim border
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- 3. Setup Mason LSP (Pass handlers directly here instead of calling setup_handlers later)
mason_lsp.setup({
  -- A list of servers to automatically install if they're not already installed
  ensure_installed = {
    "bashls",
    "cssls",
    "eslint",
    "graphql",
    "html",
    "jsonls",
    "lua_ls",
    "prismals",
    "tailwindcss",
  },
  automatic_installation = true,

  -- Handlers are now defined here
  handlers = {
    -- The first entry (without a key) will be the default handler
    function(server_name)
      require("lspconfig")[server_name].setup {
        on_attach = on_attach,
        capabilities = capabilities,
        handlers = handlers,
      }
    end,

    ["ts_ls"] = function()
      require("typescript-tools").setup({
        capabilities = capabilities or vim.lsp.protocol.make_client_capabilities(),
        handlers = require("config.lsp.servers.tsserver").handlers,
        on_attach = require("config.lsp.servers.tsserver").on_attach,
        settings = require("config.lsp.servers.tsserver").settings,
      })
    end,

    ["tailwindcss"] = function()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.colorProvider = { dynamicRegistration = false }
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      lspconfig.tailwindcss.setup({
        capabilities = capabilities,
        filetypes = require("config.lsp.servers.tailwindcss").filetypes,
        handlers = handlers,
        init_options = require("config.lsp.servers.tailwindcss").init_options,
        on_attach = require("config.lsp.servers.tailwindcss").on_attach,
        settings = require("config.lsp.servers.tailwindcss").settings,
        flags = {
          debounce_text_changes = 1000,
        },
      })
    end,

    ["cssls"] = function()
      lspconfig.cssls.setup({
        capabilities = capabilities,
        handlers = handlers,
        on_attach = require("config.lsp.servers.cssls").on_attach,
        settings = require("config.lsp.servers.cssls").settings,
      })
    end,

    ["eslint"] = function()
      lspconfig.eslint.setup({
        capabilities = capabilities,
        handlers = handlers,
        on_attach = require("config.lsp.servers.eslint").on_attach,
        settings = require("config.lsp.servers.eslint").settings,
        flags = {
          allow_incremental_sync = false,
          debounce_text_changes = 1000,
          exit_timeout = 1500,
        },
      })
    end,

    ["jsonls"] = function()
      lspconfig.jsonls.setup({
        capabilities = capabilities,
        handlers = handlers,
        on_attach = on_attach,
        settings = require("config.lsp.servers.jsonls").settings,
      })
    end,

    ["lua_ls"] = function()
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        handlers = handlers,
        on_attach = on_attach,
        settings = require("config.lsp.servers.lua_ls").settings,
      })
    end,

    ["vuels"] = function()
      lspconfig.vuels.setup({
        filetypes = require("config.lsp.servers.vuels").filetypes,
        handlers = handlers,
        init_options = require("config.lsp.servers.vuels").init_options,
        on_attach = require("config.lsp.servers.vuels").on_attach,
        settings = require("config.lsp.servers.vuels").settings,
      })
    end
  }
})

-- 4. Setup UFO
require("ufo").setup({
  fold_virt_text_handler = ufo_config_handler,
  close_fold_kinds_for_ft = { default = { "imports" } },
})
