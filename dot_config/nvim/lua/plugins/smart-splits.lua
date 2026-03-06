return {
  "mrjones2014/smart-splits.nvim",
  keys = {
    {
      "<A-Left>",
      function()
        require("smart-splits").move_cursor_left()
      end,
      desc = "Move to left window",
    },
    {
      "<A-Right>",
      function()
        require("smart-splits").move_cursor_right()
      end,
      desc = "Move to right window",
    },
    {
      "<A-Down>",
      function()
        require("smart-splits").move_cursor_down()
      end,
      desc = "Move to below window",
    },
    {
      "<A-Up>",
      function()
        require("smart-splits").move_cursor_up()
      end,
      desc = "Move to above window",
    },
  },
}
