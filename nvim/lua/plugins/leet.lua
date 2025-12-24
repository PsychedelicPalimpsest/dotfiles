return {
	"kawre/leetcode.nvim",
	build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
	dependencies = {},
	opts = {
		lang = "rust",
    hooks = {
        ---@type fun(question: lc.ui.Question)[]
        ["question_enter"] = {
          function()
            -- os.execute "sleep 1"
            local file_extension = vim.fn.expand "%:e"
            if file_extension == "rs" then
              local bash_script = tostring(vim.fn.stdpath "config" .. "/rust_leetcode_lsp.sh")
              local success, error_message = os.execute(bash_script)
              if success then
                print "Successfully updated rust-project.json"
                vim.cmd "LspRestart rust_analyzer"
              else
                print("Failed update rust-project.json. Error: " .. error_message)
              end
            end
          end,
        },
    }
	},
}
