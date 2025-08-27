-- Prompted recursive formatter using conform.nvim
vim.api.nvim_create_user_command("ConformFormatDir", function()
	local conform = require("conform")
	local uv = vim.uv or vim.loop

	local function project_root(cwd)
		local git = vim.fs.find(".git", {
			path = cwd,
			upward = true,
			type = "directory",
			limit = 1,
		})[1]
		return git and vim.fs.dirname(git) or cwd
	end

	-- Map filetypes to filename extensions to search for
	local ft_exts = {
		java = { ".java" },
		lua = { ".lua" },
		python = { ".py" },
		typescript = { ".ts", ".tsx" },
		javascript = { ".js", ".jsx", ".mjs", ".cjs" },
		go = { ".go" },
		rust = { ".rs" },
		sh = { ".sh" },
		json = { ".json" },
		yaml = { ".yml", ".yaml" },
		markdown = { ".md", ".mdx" },
	}

	local cwd = uv.cwd()
	local default_dir = project_root(cwd)

	vim.ui.input({ prompt = "Directory to format: ", default = default_dir }, function(dir)
		if not dir or dir == "" then
			vim.notify("Conform: directory not provided", vim.log.levels.WARN)
			return
		end
		dir = vim.fs.normalize(dir)

		local ft_list = vim.tbl_keys(ft_exts)
		table.sort(ft_list)
		table.insert(ft_list, 1, "all")

		vim.ui.select(ft_list, { prompt = "Language/filetype:" }, function(sel)
			if not sel then
				vim.notify("Conform: language not selected", vim.log.levels.WARN)
				return
			end

			local selected
			if sel == "all" then
				selected = vim.list_slice(ft_list, 2)
			else
				selected = { sel }
			end

			local exts = {}
			for _, ft in ipairs(selected) do
				for _, ext in ipairs(ft_exts[ft] or {}) do
					table.insert(exts, ext)
				end
			end

			local function matches_ext(name)
				for _, ext in ipairs(exts) do
					if name:sub(-#ext) == ext then
						return true
					end
				end
				return false
			end

			local files = vim.fs.find(function(name, _)
				return matches_ext(name)
			end, {
				path = dir,
				type = "file",
				limit = math.huge,
			})

			if #files == 0 then
				vim.notify("Conform: no matching files in " .. dir, vim.log.levels.INFO)
				return
			end

			vim.ui.input({
				prompt = string.format("Found %d files. Proceed? [y/N]: ", #files),
			}, function(ans)
				if not ans or ans:lower() ~= "y" then
					vim.notify("Conform: canceled", vim.log.levels.INFO)
					return
				end

				local ok_count, fail_count = 0, 0

				for _, f in ipairs(files) do
					local existing = vim.fn.bufnr(f)
					local created = existing == -1
					local bufnr = created and vim.fn.bufadd(f) or existing
					vim.fn.bufload(bufnr)

					local ok = pcall(function()
						conform.format({
							bufnr = bufnr,
							lsp_fallback = true,
							async = false,
							timeout_ms = 30000,
						})
						if vim.bo[bufnr].mod then
							vim.api.nvim_buf_call(bufnr, function()
								vim.cmd("silent write")
							end)
						end
					end)

					if ok then
						ok_count = ok_count + 1
					else
						fail_count = fail_count + 1
					end

					if created then
						pcall(vim.api.nvim_buf_delete, bufnr, { force = false })
					end
				end

				vim.notify(
					string.format("Conform: formatted %d file(s), %d failed", ok_count, fail_count),
					vim.log.levels.INFO
				)
			end)
		end)
	end)
end, { desc = "Prompt for dir and language, then format recursively with Conform" })
