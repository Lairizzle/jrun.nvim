local M = {}

function M.run()
	vim.ui.input({ prompt = "Enter the name of your Java file (e.g., Main.java): " }, function(input)
		if input == nil or input == "" then
			print("No file name provided.")
			return
		end

		local class_name = input:gsub("%.java$", "")
		local compile_cmd = "javac " .. input
		local run_cmd = "java " .. class_name

		vim.fn.jobstart(compile_cmd, {
			stdout_buffered = true,
			stderr_buffered = true,
			on_exit = function(_, code)
				if code == 0 then
					local buf = vim.api.nvim_create_buf(false, true)
					local width = math.floor(vim.o.columns * 0.8)
					local height = math.floor(vim.o.lines * 0.8)
					local row = math.floor((vim.o.lines - height) / 2)
					local col = math.floor((vim.o.columns - width) / 2)

					vim.api.nvim_open_win(buf, true, {
						relative = "editor",
						width = width,
						height = height,
						row = row,
						col = col,
						style = "minimal",
						border = "rounded",
					})

					vim.fn.termopen(run_cmd)
					vim.cmd("startinsert")
				else
					print("Compilation failed.")
				end
			end,
			on_stderr = function(_, data)
				if data then
					for _, line in ipairs(data) do
						if line ~= "" then
							print("ERROR: " .. line)
						end
					end
				end
			end,
		})
	end)
end

return M
