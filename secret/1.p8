pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- callbacks --
function _init()
	cls()
	load_dialogue()
	gt = 0
	
	x_char_lim = 128/4
	y_char_lim = 128/8
	
	bound = 127
	
	x_sep = 4
 x_offset = 1
	y_sep = 8

 chapter = 1
 dx = 1
 dialogue = 1
 dialogue_index = 1
 ttd = ""
 drawing = true
end

function _update()
 
 if btn(5) then
  dialogue_index += 1
 end
 
	if btn(3) and not(drawing) and not(#story[chapter].text == story[chapter].index) then
  story[chapter].index += 1
  drawing = true
	end
 if btn(2) and story[chapter].index > 1 then
  story[chapter].index -= 1
 end
 if btn(0) then
  chapter = 1
  dialogue_index = 1
 elseif btn(1) then
  chapter = 2
  dialogue_index = 1 
 end
	
	gt += 1
end

function _draw()
 cls()
 
 local c = story[chapter]
 local y = 0
 print(chapter, 122, 118, 7)
 
 for i=1,story[chapter].index do
  local d = c.text[i]
  local text, final, y_offset, col, x = d[1], d[2], d[3], d[4], d[5]
  
  if y_offset == nil then
   y += y_sep
  else
   y += y_offset
  end

  if x == nil then
   x = 1
  end

  if final == nil then
   final = false
  end

  if col == nil then
   col = 7
  end

 	if story[chapter].index == i and drawing then
   if dialogue_index < #text then
  		print(sub(text, 1, dialogue_index), x, y, col)
 			dialogue_index += 1
   elseif not(final) then
    print(text, x, y, col)
    story[chapter].index += 1
    dialogue_index = 1
   else
    print(text, x, y, col)
    dialogue_index = 1
    drawing = false
   end
  else
   print(text, x, y, col)
  end
 end
end
-->8
-- events --
function event()
end

function load_dialogue()
 -- format:
 -- {"text", break, verticaloffset, color, xposition}
	story = {
  {index = 1,
   text = {
 		{"i am writing this under an"},
   {"appreciable mental strain, ", true},
   {"by tonight i shall be no more.", true},
 		{"penniless,", false, 16},
   {"and at the end of my supply", true},
   {"of the drug"},
   {"which alone makes life endurable;", true},
   {"i can bear the torture no longer"}, 
   {"and shall cast myself", true},
   {"from this garret window", true},
   {"into the squalid street below.", true},
   {"...", true}}
  },{
   index = 1,
   text = {
   {"do not think"},
   {"from my slavery to morphine", true},
   {"that i am a weakling", true},
   {"or a degenerate.", true},
   {"when you have read", false, 16},
   {"these hastily scrawled pages", true},
   {"you may guess,", true},
   {"though never fully realise,", true},
   {"why it is that"},
   {"i must have forgetfulness", true},
   {"or death.", true}}
  },{
   index = 1,
   text = {
   {1, 7, "...", true}}
  }
	}
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
