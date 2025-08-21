local function get_python_path(workspace)
	-- 1. Use activated virtualenv
	if vim.env.VIRTUAL_ENV then
		return vim.env.VIRTUAL_ENV .. "/bin/python"
	end

	-- 2. Look for venv in workspace
	local venv = workspace .. "/.venv/bin/python"
	if vim.fn.executable(venv) == 1 then
		return venv
	end

	-- 3. Fallback to system python
	return "python3"
end

return {
	{
		"mason-org/mason-lspconfig.nvim",
		config = function()
			local lspconfig = require("lspconfig")
			local mason_lspconfig = require("mason-lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			mason_lspconfig.setup({
				automatic_enable = {
					"lua_ls",
					"vimls",
					"jdtls",
					"pyright",
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

			lspconfig.pyright.setup({
				capabilities = capabilities,
				on_new_config = function(config, root_dir)
					config.settings = config.settings or {}
					config.settings.python = config.settings.python or {}
					config.settings.python.pythonPath = get_python_path(root_dir)
				end,
				root_dir = lspconfig.util.root_pattern("pyproject.toml", "setup.py", "requirements.txt", ".git"),
			})

			vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "<leader>d", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "<leader>td", vim.lsp.buf.type_definition, {})
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})

			vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {})
		end,
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },

			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
		},
	},
}
