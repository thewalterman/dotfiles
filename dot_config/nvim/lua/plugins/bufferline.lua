return {
	"akinsho/bufferline.nvim",
	keys = {
		{
			"<S-Right>",
			function()
				vim.cmd("bnext " .. vim.v.count1)
			end,
			desc = "Next buffer",
		},
		{
			"<S-Left>",
			function()
				vim.cmd("bprev " .. vim.v.count1)
			end,
			desc = "Previous buffer",
		},
	},
}
