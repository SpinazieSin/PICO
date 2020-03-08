pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function _init()
	textcols = {9, 7, 7, 7}
	textadd = {"", "", "", ""}
end

function _update()
 if btn(0) then
		textcols = {9, 7, 7, 7}
		textadd = {"", "", "", ""}
 end
 if btn(1) then
		textcols = {7, 9, 7, 7}
		textadd = {"", "", "", ""}
 end	
end

function _draw()
 cls(1)
 rectfill(0, 100, 127, 127, 0) 
	rectfill(0, 100, 127, 100, 6)
	print(textadd[1].."slap", 25, 106, textcols[1])
	print(textadd[2].."throw", 80, 106, textcols[2])
end

__gfx__
00000000666666666666666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000677777777777777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700670000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000670000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000670000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700670000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000670000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000670000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
