return {
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")
			lint.linters.gdscript_formatter = {
				name = "gdscript_formatter",
				cmd = "gdscript-formatter",
				args = { "lint" },
				stdin = false,
				append_fname = true,
				stream = "stdout",
				ignore_exitcode = true,
				parser = require("lint.parser").from_pattern(
					[[^(.+):(%d+):([^:]+):([^:]+):%s*(.*)$]],
					{ "file", "lnum", "code", "severity", "message" },
					{
						error = vim.diagnostic.severity.ERROR,
						Error = vim.diagnostic.severity.ERROR,
						warning = vim.diagnostic.severity.WARN,
						Warning = vim.diagnostic.severity.WARN,
						info = vim.diagnostic.severity.INFO,
						Info = vim.diagnostic.severity.INFO,
					},
					{ source = "gdscript-formatter" }
				),
			}

			lint.linters_by_ft = {
				dockerfile = { "hadolint" },
				gdscript = { "gdscript_formatter" },
				go = { "golangcilint" },
				markdown = { "markdownlint" },
				terraform = { "tflint" },
			}

			-- Create autocommand which carries out the actual linting
			-- on the specified events.
			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					-- Only run the linter in buffers that you can modify in order to
					-- avoid superfluous noise, notably within the handy LSP pop-ups that
					-- describe the hovered symbol using Markdown.
					if vim.bo.modifiable then
						lint.try_lint()
					end
				end,
			})
		end,
	},
}
