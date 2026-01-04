return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"williamboman/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		require("mason-nvim-dap").setup({
			ensure_installed = { "codelldb" },
			handlers = {},
			automatic_installation = true,
		})

		dapui.setup()

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		dap.configurations.cpp = {
			{
				name = "Launch file",
				type = "codelldb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
			},
		}

		dap.configurations.c = dap.configurations.cpp
		dap.configurations.rust = dap.configurations.cpp

		vim.keymap.set("n", "<F5>", function()
			dap.continue()
		end, { desc = "Debug: Start/Continue" })

		vim.keymap.set("n", "<F1>", function()
			dap.step_over()
		end, { desc = "Debug: Step Over" })

		vim.keymap.set("n", "<F2>", function()
			dap.step_into()
		end, { desc = "Debug: Step Into" })

		vim.keymap.set("n", "<F3>", function()
			dap.step_out()
		end, { desc = "Debug: Step Out" })

		vim.keymap.set("n", "<F12>", function()
			dap.toggle_breakpoint()
		end, { desc = "Debug: Toggle Breakpoint" })

		vim.keymap.set("n", "<leader>d-", function()
			require("dap").restart()
		end, { desc = "Debug: Restart" })
		vim.keymap.set("n", "<leader>d_", function()
			require("dap").terminate()
			require("dapui").close()
		end, { desc = "Debug: close" })

		vim.keymap.set("n", "<leader>B", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end, { desc = "Debug: Conditional Breakpoint" })
	end,
}
