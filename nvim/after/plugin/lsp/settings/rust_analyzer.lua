return {
    settings = {
        ["rust-analyzer"] = {
            checkOnSave = {
                command = "clippy",
                allFeatures = true,
                overrideCommand = {
                    'cargo', 'clippy', '--workspace', '--message-format=json',
                    '--all-targets', '--all-features'
                }
            },
        }
    }
}
