return {
  {
    "Pocco81/auto-save.nvim",
    opts = {
      condition = function(buf)
        local fn = vim.fn
        local utils = require("auto-save.utils.data")

        -- only save if buffer is modifiable AND has a filename
        local has_file = fn.expand("#" .. buf .. ":p") ~= ""

        if
          has_file
          and fn.getbufvar(buf, "&modifiable") == 1
          and utils.not_in(fn.getbufvar(buf, "&filetype"), {})
        then
          return true
        end

        return false
      end,
    },
  },
}
