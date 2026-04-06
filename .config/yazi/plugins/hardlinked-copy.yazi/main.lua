--- @since 26.1.22

local get_hovered_url = ya.sync(function()
	local hovered = cx.active.current.hovered
	return hovered and tostring(hovered.url) or nil
end)

local function script_path()
	local config_home = os.getenv('YAZI_CONFIG_HOME')
	if config_home and config_home ~= '' then
		return config_home .. '/plugins/hardlinked-copy.yazi/hardlinked_copy.py'
	end

	return os.getenv('HOME') .. '/.config/yazi/plugins/hardlinked-copy.yazi/hardlinked_copy.py'
end

local function trim_newlines(value)
	return value:gsub('[\r\n]+$', '')
end

return {
	entry = function()
		local hovered_url = get_hovered_url()
		if not hovered_url then
			ya.notify({
				title = 'Hardlinked copy',
				content = 'No hovered entry',
				level = 'warn',
				timeout = 4,
			})
			return
		end

		local output, err = Command('python3')
			:arg({ script_path(), hovered_url })
			:stdout(Command.PIPED)
			:stderr(Command.PIPED)
			:output()

		if err then
			ya.notify({
				title = 'Hardlinked copy',
				content = tostring(err),
				level = 'error',
				timeout = 8,
			})
			return
		end

		if not output.status.success then
			local message = trim_newlines(output.stderr)
			if message == '' then
				message = 'Command failed'
			end

			ya.notify({
				title = 'Hardlinked copy',
				content = message,
				level = 'error',
				timeout = 8,
			})
			return
		end

		local destination = trim_newlines(output.stdout)
		if destination == '' then
			ya.notify({
				title = 'Hardlinked copy',
				content = 'Helper did not report the destination path',
				level = 'error',
				timeout = 8,
			})
			return
		end

		ya.emit('reveal', { Url(destination) })
		ya.notify({
			title = 'Hardlinked copy',
			content = 'Created ' .. destination,
			timeout = 4,
		})
	end,
}
