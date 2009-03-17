-- Writed by jiang jian hong
-- Date 2007.01.06
-- Tools for set the amixer volume


-- defbindings("WMPlex.toplevel", {
--   kpress("F11", "VolumeSetter.up()"),  -- sound up
--   kpress("F10", "VolumeSetter.down()"), -- sound down
-- })



VolumeSetter = {}

local limit = 31
local current = 0
local step = 3.2
local status

local command = "amixer sset Master "

local function get_volume()
   	local f=io.popen('amixer','r')
   	local s=f:read('*all')
   	f:close()
   	local _, _, master_level, master_state = string.find(s, "%[(%d*)%%%] %[(%a*)%]")
   	local sound_state = ""
   	if master_state == "off" then
      		sound_state = "MUTE "
		status = 0
   	end
  	return master_level.."", sound_state..""
end

--[[
function VolumeSetter.up()
	local strCMD
	current, status = get_volume()
	current = tonumber(current) * 0.32
	if current <= limit then
		current = current + step
		if current >= limit then
			current = limit
		end
		strCMD = string.format("%d", current)
		--strCMD = "10%+"
		io.popen(command..strCMD,'r')
	end
end
--]]

function VolumeSetter.up()
	local strCMD = "10%+"
	io.popen(command..strCMD,'r')
end

--[[
function VolumeSetter.down()
	local strCMD
	current, status = get_volume()
	current = tonumber(current) * 0.32
	if current > 0 then
		current = current - step
		if current < 0 then
			current = 0
		end
		strCMD = string.format("%d", current)
		--strCMD = "10%-"
		io.popen(command..strCMD,'r')
	end
end
--]]

function VolumeSetter.down()
	local strCMD = "10%-"
	io.popen(command..strCMD,'r')
end


function VolumeSetter.mute()

	io.popen(command.." toggle", 'r')
	--[[
	--get_volume()
	if status ~= 0 then
		io.popen(command.."mute",'r')
	else
		io.popen(command.."on",'r')
		status = 1
	end
	----]]
end



defbindings("WMPlex.toplevel", {
   kpress("Shift+F12", "VolumeSetter.up()"),  -- sound up
   kpress("Shift+F11", "VolumeSetter.down()"), -- sound down
   kpress("Shift+F10", "VolumeSetter.mute()"), -- mute sound
})
