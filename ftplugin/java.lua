vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.cmdheight = 1
vim.opt.scrolloff = 8

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local workspace_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local bundles = {
  vim.fn.glob(
    '/home/amin_said/Java/Lsp/plugins/org.eclipse.jdt.core_*.jar',
    true),
  vim.fn.glob(
    '/home/amin_said/nvimFunctionality/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar',
    true),
}
vim.list_extend(bundles,
  vim.split(vim.fn.glob('/home/amin_said/nvimFunctionality/vscode-java-test/server/*.jar', true), '\n'))

local config = {
  cmd = { "java",
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.level=ALL',
    -- '-noverify',
    -- '-Xms1G',
    '-jar',
    vim.fn.glob(
      '/home/amin_said/Java/Lsp/plugins/org.eclipse.equinox.launcher_*.jar'),
    '-javaagent', "/home/amin_said/.config/nvim/lombok.jar",
    '-configuration', '/home/amin_said/Java/Lsp/config_linux',
    '-data', vim.fn.expand('/home/amin_said/workspace/Java/') .. workspace_dir,
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
  },
  init_options = {
    bundles = bundles,
  },
  -- root_dir = vim.fs.dirname(vim.fs.find({ '.gradlew', '.git', 'mvnw' }, { upward = true })[1]),
  root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew" }),
  capabilities = capabilities,
  settings = {
    java = {
      format = {
        settings = {
          -- Use Google Java style guidelines for formatting
          -- To use, make sure to download the file from https://github.com/google/styleguide/blob/gh-pages/eclipse-java-google-style.xml
          url = "/home/amin_said/.config/nvim/eclipse-java-google-style.xml",
          profile = "GoogleStyle",
        },
      },
      signatureHelp = { enabled = true },
      --contentProvider = { preferred = 'fernflower' },  -- Use fernflower to decompile library code
      -- Specify any completion options
      completion = {
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*",
        },
        filteredTypes = {
          "com.sun.*",
          "io.micrometer.shaded.*",
          "java.awt.*",
          "jdk.*", "sun.*",
        },
      },
      -- Specify any options for organizing imports
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      -- How code generation should act
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
        },
        useBlocks = true,
      },
      -- If you are developing in projects with different Java versions, you need
      -- to tell eclipse.jdt.ls to use the location of the JDK for your Java version
      -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
      -- And search for `interface RuntimeOption`
      -- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
      configuration = {
      }
    }
  }
}

config['on_attach'] = function(_, bufnr)
  -- With `hotcodereplace = 'auto' the debug adapter will try to apply code changes
  -- you make during a debug session immediately.
  -- Remove the option if you do not want that.

  local nmap = function(keys, func, desc)
    if desc then
      desc = 'JDTLS: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end


  local vmap = function(keys, func, desc)
    if desc then
      desc = 'JDTLS: ' .. desc
    end

    vim.keymap.set('v', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>wd', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
  nmap('<leader>f', vim.lsp.buf.format, '[F]ormatting')

  -- See `:help K` for why this keymap
  nmap('<leader>k', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  nmap('<leader>co', '<Cmd>lua require(\'jdtls\').organize_imports()<CR>', 'Organize Imports')
  nmap('<leader>cv', '<Cmd>lua require(\'jdtls\').extract_variable()<CR>', 'Extract Variable')
  vmap('<leader>cv', '<Esc><Cmd>lua require(\'jdtls\').extract_variable(true)<CR>', 'Extract Variable')
  nmap('<leader>cc', '<Cmd>lua require(\'jdtls\').extract_constant()<CR>', 'Extract Constant')
  vmap('<leader>cc', '<Esc><Cmd>lua require(\'jdtls\').extract_constant(true)<CR>', 'Extract Constant')
  vmap('<leader>cm', '<Esc><Cmd>lua require(\'jdtls\').extract_method(true)<CR>', 'Extract Method')
  nmap('<leader>df', '<Cmd>lua require(\'jdtls\').test_class()<CR>', 'Test Class')
  nmap('<leader>dn', '<Cmd>lua require(\'jdtls\').test_nearest_method()<CR>', 'Test Nearest Method')

  nmap('<Leader>dj', '<Cmd>JdtUpdateConfig<CR>', 'Update DAP Config')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
  require('jdtls').setup_dap({ hotcodereplace = 'auto' })
  require("jdtls.dap").setup_dap_main_class_configs()
end

vim.cmd([[ command! LspToggleAutoFormat execute 'lua require("lsp.handlers").toggle_format_on_save()' ]])
require('jdtls').start_or_attach(config)
