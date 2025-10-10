return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        transparent = vim.g.transparent_enabled,
        styles = { sidebars = "transparent", floats = "transparent" },
      })
      vim.cmd([[colorscheme tokyonight]])

      -- Force barbar to be transparent
      local function barbar_transparent()
        local groups = {

          "BufferTabpages",
          "BufferTabpageFill",
          "BufferOffset",
          "TabLineFill",
          "BufferInactive"
        }
        for _, g in ipairs(groups) do
          pcall(vim.api.nvim_set_hl, 0, g, { bg = "NONE" })
        end

          pcall(vim.api.nvim_set_hl, 0, "BufferCurrent", { bg = "#00000020" })
      end

      -- Apply now and keep reapplying after colorscheme/plugin load
      barbar_transparent()
      vim.api.nvim_create_autocmd(
        { "ColorScheme", "VimEnter", "BufWinEnter" },
        {
          group = vim.api.nvim_create_augroup(
            "BarbarTransparent",
            { clear = true }
          ),
          callback = barbar_transparent,
        }
      )
    end,
  },
}
