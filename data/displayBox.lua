
defaults = T{}
defaults.text_R = 255 --Color values are in RGB, ranging from 0 to 255
defaults.text_G = 255
defaults.text_B = 255

defaults.green_R = 0
defaults.green_G = 255
defaults.green_B = 0

defaults.red_R = 255
defaults.red_G = 0
defaults.red_B = 0

defaults.yellow_R = 255
defaults.yellow_G = 255
defaults.yellow_B = 0

defaults.pos_x = 0
defaults.pos_y = 0
defaults.font_size = 11
defaults.bg_alpha = 255

green_col = "\\cs("..tostring(defaults.green_R)..","..tostring(defaults.green_G)..","..tostring(defaults.green_B)..")"
red_col = "\\cs("..tostring(defaults.red_R)..","..tostring(defaults.red_G)..","..tostring(defaults.red_B)..")"
yellow_col = "\\cs("..tostring(defaults.yellow_R)..","..tostring(defaults.yellow_G)..","..tostring(defaults.yellow_B)..")"

white_col = "\\cs("..tostring(defaults.text_R)..","..tostring(defaults.text_G)..","..tostring(defaults.text_B)..")"


msgKeys = {}
msgTable = {}

textColorKeys = {}
textColorPairs = {}

colorMaps = {}

function setupColors()
	colorMaps["yellow"] = yellow_col
	colorMaps["green"] = green_col
	colorMaps["red"] = red_col
	colorMaps["white"] = white_col
end

function addToTable(key, value) 
	if (noValue(key, msgKeys)) then
		table.insert(msgKeys, key)
	end
	msgTable[key] = value
end

function addTextColorPair(key, color)
	if (noValue(key, textColorKeys)) then
		table.insert(textColorKeys, key)
		textColorPairs[key] = color
	end
end

function noValue(key, inputTable)
	for _, k in ipairs(inputTable) do
		if (k == key) then
			return false
		end
	end
	return true
end

function text_setup()
	setupColors()
	addTextColorPair("true", "green")
	addTextColorPair("false", "red")

	msg_settings = {}
	msg_settings.pos = {}
	msg_settings.pos.x = 1300
	msg_settings.pos.y = 800
	msg_settings.text = {}
	msg_settings.text.font = "Consolas"
	msg_settings.text.size = 11
	msg_settings.flags = {}

	msg_box = texts.new('', msg_settings)
	msg_box:show()
	update_message()
end

function update_message()
	msg = ""
	for _, k in ipairs(msgKeys) do
		msg = msg..k..": "
		msg = msg..colorMsg(msgTable[k])..'\n'
	end
	msg_box:text(msg)

	msg_box:show()
end

function print_table() 
	for _, k in ipairs(msgKeys) do
		add_to_chat(140,k.." "..string.format(msgTable[k] and 'true' or 'false'))
	end
end

function colorMsg(msg)
	if (type(msg) == "boolean") then
		msg = string.format(msg and 'true' or 'false')
	end
	if (noValue(msg, textColorKeys) == false) then
		return colorMaps[textColorPairs[msg]]..msg..colorMaps["white"]
 	end
	return msg
end
