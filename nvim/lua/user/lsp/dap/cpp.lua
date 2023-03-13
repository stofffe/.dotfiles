local dap = require("dap")

-- INFO: execute ~/Downloads/vscode-extensions/codelldb/extension/adapter/codelldb --port 13000
dap.adapters.codelldb = {
    type = 'server',
    host = '127.0.0.1',
    port = 13000,
}

dap.configurations.c = {
    {
        type = 'codelldb',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        --program = '${fileDirname}/${fileBasenameNoExtension}',
        cwd = '${workspaceFolder}',
        terminal = 'integrated'
    }
}

dap.configurations.cpp = dap.configurations.c
