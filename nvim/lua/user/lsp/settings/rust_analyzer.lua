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

-- https://github.com/rust-lang/rust-analyzer/blob/master/docs/user/generated_config.adoc
