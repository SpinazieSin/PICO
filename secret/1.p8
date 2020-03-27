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
 
	if btn(3) and not(drawing) and not(#chapters[chapter] == dialogue) then
  dialogue += 1
  drawing = true
	end
 if btn(2) and dialogue > 1 then
  dialogue -= 1
 end
 if btn(0) then
  chapter = 1
  dialogue = 1
  dialogue_index = 1
 elseif btn(1) then
  chapter = 2
  dialogue = 1
  dialogue_index = 1 
 end
	
	gt += 1
end

function _draw()
 cls()
 
 local c = chapters[chapter]
 print(chapter, 122, 118, 7)
 
 for i=1,dialogue do
  local d = c[i]
  local y, col, text, final, x = d[1], d[2], d[3], d[4], d[5]
  
  if x == nil then
   x = 1
  end

  if final == nil then
   final = false
  end

 	if dialogue == i and drawing then
   if dialogue_index < #text then
  		print(sub(text, 1, dialogue_index), x, y, col)
 			dialogue_index += 1
   elseif not(final) then
    print(text, x, y, col)
    dialogue += 1
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
	chapters = {
  {
 		{1, 7, "i am writing this under an"},
   {10, 7, "appreciable mental strain, ", true},
   {19, 7, "by tonight i shall be no more.", true},
 		{32, 7, "penniless,"},
   {41, 7, "and at the end of my supply", true},
   {50, 7, "of the drug"},
   {59, 7, "which alone makes life endurable;", true},
   {68, 7, "i can bear the torture no longer"}, 
   {77, 7, "and shall cast myself", true},
   {86, 7, "from this garret window", true},
   {95, 7, "into the squalid street below.", true},
   {37, 7, "...", true}
  },{
   {1, 7, "do not think from my slavery to morphine that i am a weakling or a degenerate. when you have read these hastily scrawled pages you may guess, though never fully realise, why it is that i must have forgetfulness or death."},
   {10, 7, "...", true}
  },{
   {1, 7, "...", true}
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
