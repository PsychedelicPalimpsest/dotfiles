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
					xmlformatter = {
						-- Configure using valid xmlformat args
						prepend_args = {
							"--indent",
							"4", -- Use 4 spaces
							"--indent-char",
							" ", -- Space character for indentation
							"--selfclose", -- Compact self-closing tags (<tag .../>)
							"--preserve-attributes", -- Keeps attribute structure intact
							"--eof-newline", -- Add newline at EOF
							"--disable-inlineformatting", -- Prevents inline text compression
							"--blanks", -- Look good
						},
					},
				},

				formatters_by_ft = {
					lua = { "stylua" },
					go = { "gofmt" },
					javascript = { "prettier" },
					typescript = { "prettier" },
					markdown = { "prettier" },
					rust = { "rustfmt" },
					elixir = { "mix" },
					java = { "clang-format" },
					python = { "black" },
					c = { "clang_format" },
					bash = { "beautysh" },
					sh = { "beautysh" },
					xml = { "xmlformatter" },
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
