vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.keymap.set("n", "<leader>F", function()
	require("conform").format({ bufnr = 0 })
end)

vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal left<CR>", {})
vim.keymap.set("n", "|", ":Neotree filesystem toggle left<CR>", {})
vim.keymap.set("", "<C-b>", ":Neotree buffers reveal float<CR>", {})

vim.keymap.set("n", "U", "<C-R>")

vim.keymap.set("n", "<leader>t", ":terminal<CR>", {})
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")



vim.api.nvim_create_augroup("python_folds", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "python_folds",
  pattern = "python",
  callback = function()
    vim.opt_local.foldmethod = "indent"
  end,
})


require("recursive_format")
