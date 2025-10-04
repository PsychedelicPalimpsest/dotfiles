return {
	{
		"stevearc/conform.nvim",
		opts = {},
		config = function()
			require("conform").setup({
				formatters = {
					clang_format = {
						command = "clang-format",
						args = { "--assume-filename", "dummy.java" },
						stdin = true,
					},
				},

				formatters_by_ft = {
					lua = { "stylua" },
					go = { "gofmt" },
					javascript = { "prettier" },
					typescript = { "prettier" },
					elixir = { "mix" },
					java = { "clang-format" },
					python = { "black" },
					c = { "clang_format" },
          bash = { "beautysh" },
          sh = { "beautysh" }
				},

			})
		end,
	},
	{
		"mfussenegger/nvim-lint",
		config = function()
			require("lint").linters_by_ft = {
				markdown = { "vale" },
				lua = { "luac" },
			}
		end,
	},
}
