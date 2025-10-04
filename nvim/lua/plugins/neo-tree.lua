return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("transparent").clear_prefix("NeoTree")
		require("neo-tree").setup({
			window = {
				width = 25, -- default is 40, you can shrink this
			},
		})
	end,
}
