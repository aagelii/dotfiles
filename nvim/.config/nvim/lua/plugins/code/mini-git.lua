return {
	"echasnovski/mini-git",
	version = false,
	event = { "BufReadPost", "BufWritePost", "BufNewFile" },
	main = "mini.git",
	opts = {
		-- General CLI execution
		job = {
			-- Path to Git executable
			git_executable = "git",

			-- Timeout (in ms) for each job before force quit
			timeout = 30000,
		},

		-- Options for `:Git` command
		command = {
			-- Default split direction
			split = "auto",
		},
	},
	config = true,
}
