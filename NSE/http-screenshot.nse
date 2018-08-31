description = [[
Gets a screenshot from the host
]]

author = "Ryan Linn <rlinn at trustwave.com>"

license = "GPLv2"

categories = {"discovery", "safe"}

-- Updated the NSE Script imports and variable declarations
local shortport = require "shortport"

local stdnse = require "stdnse"

portrule = shortport.http

action = function(host, port)
	-- Check to see if ssl is enabled, if it is, this will be set to "ssl"
	local ssl = port.version.service_tunnel

	-- The default URLs will start with http://
	local prefix = "http"

	-- Screenshots will be called screenshot-namp-<IP>:<port>.png
        local filename = "screenshot-nmap-" .. host.ip .. ":" .. port.number .. ".png"
	
	-- If SSL is set on the port, switch the prefix to https
	if ssl == "ssl" then
		prefix = "https"	
	end

	-- Execute the shell command wkhtmltoimage-i386 <url> <filename>
	local cmd = "chromium-browser --no-sandbox --headless" .. " --screenshot=" .. filename .. " " .. prefix .. "://" .. host.ip .. ":" .. port.number .. " 2> /dev/null   >/dev/null"
	
	print(cmd)
	local ret = os.execute(cmd)

	-- If the command was successful, print the saved message, otherwise print the fail message
	local result = "failed (verify chromium-browser is in your path)"

	if ret then
		result = "Saved to " .. filename
	end

	-- Return the output message
	return stdnse.format_output(true,  result)

end

