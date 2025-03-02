local source = {}

local utils = require("cmp_go_pkgs.utils")

local items = {}

source.new = function()
	return setmetatable({}, { __index = source })
end

-- Init items for bufnr. Call in autocmd on LspAttach event
source.init_items = function(args)
	local client = vim.lsp.get_client_by_id(args.data.client_id)

	local bufnr = vim.api.nvim_get_current_buf()
	local uri = vim.uri_from_bufnr(bufnr)

	local arguments = { { uri = uri } }

	if client == nil then
		return
	end

	client.request("workspace/executeCommand", {
		command = "gopls.list_known_packages",
		arguments = arguments,
	}, function(error, result, _)
		if error ~= nil then
			return
		end

		if result == nil then
			return
		end

		local tmp = {}

		for _, package in ipairs(result.Packages) do
			table.insert(tmp, {
				label = package,
				kind = 9,
				insertText = package,
			})
		end

		items[bufnr] = tmp
	end, bufnr)
end

source.complete = function(_, params, callback)
	local bufnr = vim.api.nvim_get_current_buf()

	if next(items) == nil or items[bufnr] == nil then
		callback()
		return
	end

	callback({
		items = utils.filter_items_by_prefix(items[bufnr], params.context.cursor_before_line),
		isIncomplete = false,
	})
end

source.is_available = function()
	return vim.bo.filetype == "go" and utils.check_if_inside_imports()
end

source.get_keyword_pattern = function()
	return [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\|/\)]]
end

return source
