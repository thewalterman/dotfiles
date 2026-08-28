local config_path = vim.fn.stdpath("cache") .. "/markdownlint.jsonc"
vim.fn.writefile({ '{ "MD013": false }' }, config_path)

return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          prepend_args = { "--config", config_path },
        },
      },
    },
  },
}
