return {
  "folke/snacks.nvim",
  opts = {
    notifier = {
      filter = function(notif)
        return not notif.msg:match("^herdr%-nvim: not overriding existing map")
      end,
    },
    picker = {
      hidden = true,
      exclude = {
        "**/.git",
      },
      sources = {
        files = {
          hidden = true,
        },
      },
    },
  },
}
