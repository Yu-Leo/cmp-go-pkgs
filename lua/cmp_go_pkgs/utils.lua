local M = {}

---Get substring from " character
---@param a string
---@return string
local function get_prefix(a)
	local _, pos = string.find(a, '"')

	if pos then
		return string.sub(a, pos + 1)
	end

	return ""
end

---If prompt contains "/" filter items by prefix from "
---@param items table
---@param prompt string
---@return table
M.filter_items_by_prefix = function(items, prompt)
	local prefix = get_prefix(prompt)

	if not string.find(prefix, "/") then
		return items
	end

	local result = {}

	for _, item in ipairs(items) do
		if item.insertText and string.sub(item.insertText, 1, #prefix) == prefix then
			table.insert(result, item)
		end
	end

	return result
end

---Checks whether the cursor is in the "import" section
---@return boolean
M.check_if_inside_imports = function()
	local cur_node = require("nvim-treesitter.ts_utils").get_node_at_cursor()
	local is_in_string = false

	while cur_node do
		local node_type = cur_node:type()

		if node_type == "interpreted_string_literal" then
			is_in_string = true
		end

		if node_type == "import_declaration" then
			return is_in_string
		end

		cur_node = cur_node:parent()
	end

	return false
end

return M
