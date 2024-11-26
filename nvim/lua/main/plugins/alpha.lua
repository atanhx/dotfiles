return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	dependencies = { "RchrdAriza/nvim-web-devicons" },
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		local time = os.date("%H:%M")
		local date = os.date("%a %d %b")
		local v = vim.version()
		local version = " v" .. v.major .. "." .. v.minor .. "." .. v.patch

		-- Set header
		dashboard.section.header.val = {
			"                       ███                ",
			"                      ░░░                 ",
			" ████████  █████ █████████ █████████████  ",
			"░░███░░███░░███ ░░███░░███░░███░░███░░███ ",
			" ░███ ░███ ░███  ░███ ░███ ░███ ░███ ░███ ",
			" ░███ ░███ ░░███ ███  ░███ ░███ ░███ ░███ ",
			" ████ █████ ░░█████   ██████████░███ █████",
			"░░░░ ░░░░░   ░░░░░   ░░░░░░░░░░ ░░░ ░░░░░ ",
		}

		dashboard.section.buttons.val = {
			dashboard.button("e", "   New file", ":ene <BAR> startinsert <CR>"),
			dashboard.button("<space>ff", "󰮗   Find file", ":cd $HOME | Telescope find_files<CR>"),
			dashboard.button("<alt>p", "   File Explorer", ":cd $HOME | Neotree<CR>"),
			dashboard.button("<space>fo", "   Recent", ":Telescope oldfiles<CR>"),
			dashboard.button("c", "   Configuration", ":e ~/.config/nvim/lua/user/config.lua<CR>"),
			dashboard.button("<space>fw", "󱘞   Ripgrep", ":Telescope live_grep<CR>"),
			dashboard.button("q", "󰗼   Quit", ":qa<CR>"),
		}

		function centerText(text, width)
			local totalPadding = width - #text
			local leftPadding = math.floor(totalPadding / 2)
			local rightPadding = totalPadding - leftPadding
			return string.rep(" ", leftPadding) .. text .. string.rep(" ", rightPadding)
		end

		dashboard.section.footer.val = {
			centerText("atanhx", 50),
			" ",
			centerText(date, 50),
			centerText(time, 50),
			centerText(version, 50),
		}

		alpha.setup(dashboard.opts)
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
	end,
}
