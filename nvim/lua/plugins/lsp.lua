return {
	{
		"mason-org/mason-lspconfig.nvim",
		config = function()
			local lspconfig = require("lspconfig")
			local mason_lspconfig = require("mason-lspconfig")

			mason_lspconfig.setup({
				automatic_enable = {
					"lua_ls",
					"vimls",
					"jdtls",
				},
			})
			-- Java setup
			lspconfig.jdtls.setup({
				cmd = { "jdtls" },
				root_dir = lspconfig.util.root_pattern("gradlew", ".git", "mvnw"),
				settings = {
					java = {
						configuration = {
							runtimes = {
								{
									name = "JavaSE-17",
									path = "/usr/lib/jvm/java-17-openjdk/",
								},
							},
						},
					},
				},
			})

			vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "<leader>d", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "<leader>td", vim.lsp.buf.type_definition, {})
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})

			vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {})
		end,
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			{
				"neovim/nvim-lspconfig"
			},
		},
	},
}
