pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- main functions --
function _init()
 -- gametime
 gt = 0
 gamestart = true
 event = false
 
 -- shaymin variables
 sprite = 16
 sx, sy = 20, 90
 dsy = 0
 sleeptimer = 0
 sleeping = true
 sleeping_dir = 1
 left, jump, up, vine = false, false, false, false

	-- flower and branch colors
	flwrcols = {7, 8, 9, 10, 14}
	brnchcols = {3, 11}
	flowers = {}

 -- screen variables
 scroll_dir_x, scroll_dir_y = 0, 0
 mid_screen_x, mid_screen_y = 63, 63
 camx, camy = 0, 0
 background_color = 12
 fading = 0
 fadespeed = 90
 dark, setdarkness = false, false

 -- npc variables
 units = {}
 add_unit(63, 63, 1, 0)
end

function _update()
 -- scroll the screen
 scroll_screen()

 -- increment gametime
 if not(event) then
  gt += 1
  if btn(4) then
  	sfx(1)
  end
 else

  -- scroll camera
  if not(scroll_dir_x == 0) then
   camx += scroll_dir_x
   camera(camx, camy)
   if camx % 128 == 0 then
    scroll_dir_x = 0
    event = false
   end
  elseif not(scroll_dir_y == 0) then
   camy += scroll_dir_y
   camera(camx, camy)
   if camy % 128 == 0 then
    scroll_dir_y = 0
    event = false
   end
  end
 end
 
 -- move shaymin
 move()

 -- falling
 if not(fget(mget((sx+1)/8, (sy+6)/8), 0) or fget(mget((sx+6)/8, (sy+6)/8), 0)) and not(vine or up or event) then
  dsy+= 0.2
  if (dsy > 1) dsy = 1
  sy += flr(dsy)
  sprite = 3
 elseif not(jump or vine or sleeping) then
  sprite = 1
  dsy = 0
 end

 -- update npcs
 for unit in all(units) do
  unit:update()
 end

 -- move npcs
 for unit in all(units) do
  unit:move()
 end
 
 -- update shaymins flowers
 for flwr in all(flowers) do
 	flwr:update()
 end
end

function _draw()
 cls(background_color)
 map()
 
 for unit in all(units) do
  unit:draw()
 end

 for flwr in all(flowers) do
 	flwr:draw()
 end

 local hmirror = false
 if left and not(sprite > 4 and sprite < 7) then
  hmirror = true
 end
 spr(sprite, sx, sy, 1, 1, hmirror) 
end

-->8
-- movement functions --
function move()
 if sleeping then
  if sleeptimer < 180 then
   sleeptimer += 1
  elseif not(gamestart) and not(setdarkness) then
   if not(dark) then
    fadeout()
    dark = true
    fading = 0
   else
    pal()
    dark = false
    fading = 0
   end
   setdarkness = true
  end
  
  if sprite < 16 then
   sprite = 19
   sleeping_dir = -1
  end

  if sprite == 16 and (btn(4) or btn(5)) then
   sprite += 1
   sleeping_dir = 1
   sleeptimer = 0
  end

  if sprite > 16 and gt%10 == 0 then
   sprite += sleeping_dir
  end
  
  if sprite == 20 then
   sprite = 1
   sleeping = false
   gamestart = false
   setdarkness = fals
  end
 else
  move_shaymin()
 end
end

function move_shaymin()
 -- gotosleep
 if btn(3) and not(vine) then
  sleeping = true
  jump = false
 end

 -- move left or right
 if btn(0) then 
  left = true
  if vine then
   vine = false
   sprite = 1
  end
 elseif btn(1) then
  left = false
  if vine then
   vine = false
   sprite = 1
  end
 end

 -- climb
 if fget(mget((sx+3)/8, (sy+5)/8), 1) then
  if btn(2) then
   vine = true
   if (sprite < 5) sprite = 5
  end
 else
  vine = false
 end

 -- get input for jump
 if btn(5) and not(jump) then
  jump = true
  sfx(2) 
 end

 -- jump shaymin
 if jump and gt%5 == 0 then
  if vine then
   if gt%10 == 0 then
    sprite += 1
    sy -= 1
    if sprite > 6 then
     sprite = 5
     jump = false
    end
   end
  else
   sprite += 1
   if left then
    if not(fget(mget((sx)/8, (sy+5)/8), 0)) then
     sx -= 1
     add_flower(sx+7, sy+5)
    end
   else
    if not(fget(mget((sx+7)/8, (sy+5)/8), 0)) then
     sx += 1
     add_flower(sx+1, sy+5)
    end
   end
   
   if sprite > 3 then
    sprite = 1
    jump = false
   end
  end
  if btn(5) then
   gt += 1
  end
 end
end

function scroll_screen()
 if (sx+3)%127 == 0 and sx > 0 then
  event = true
  if sx > mid_screen_x then
   sx += 5
   scroll_dir_x = 2
   mid_screen_x += 127
  elseif sx < mid_screen_x then
   sx -= 5
   scroll_dir_x = -2
   mid_screen_x -= 127
  end
 end
 if (sy+3)%127 == 0 then
  event = true
  if sy > mid_screen_y then
   sy += 5
   scroll_dir_y = 2
   mid_screen_y += 127
  elseif sy < mid_screen_y then
   sy -= 5
   scroll_dir_y = -2
   mid_screen_y -= 127
  end
 end
end

function fadeout()
 fading+=1
 if fading%fadespeed==1 then
  for i in all({7, 3,11,4,5,6,12,14}) do
   pal(i, 128+i, 1)
  end
 end
end

function fadein()
 pal()
end

-->8
-- particles --
function add_flower(x, y)
 -- random chance to spawn flower
 if (rnd(100) < 80 or not(fget(mget(x/8, (y+1)/8), 7))) return

 local x = x or sx
 local y = y or sy
 local brnch = brnchcols[flr(1+rnd(2))]
 local flwr = flwrcols[flr(1+rnd(5))]
	local life = rnd(40) + 1
 local bloom_size = rnd(2)
	add(flowers, {
		x = x,
		y = y,
		h = 0,
		brnch = brnch,
		flwr = flwr,
		life = life,
  bloom_size = bloom_size,
  bloom = false,
		update = function(self)
			if self.life > 0 then
				self.life -= 1
				self.h += 0.1
			elseif not(self.bloom) then
    self.bloom = true
   end
		end,
		
		draw = function(self)
   local wave = flr(sin(gt/80))
   line(self.x, self.y, self.x + wave, self.y - self.h, self.brnch)
   if self.bloom then

    circfill(self.x + wave, self.y - self.h, self.bloom_size, self.flwr)
   end
		end
	})
end

-->8
-- add unit --
function add_unit(x, y, unit_number, event)
 local x = x or mid_screen_x
 local y = y or mid_screen_y
 local unit_number = unit_number or 1
 local event = event or 0

 add(units, {
  x = x,
  y = y,
  unit_number = unit_number,
  event = event,
  timer = 0,

  update = function(self)
   -- npc state
   local x = self.x
   local y = self.y
   local timer = self.timer
   local unit_number = self.unit_number
   local event = self.event

   -- update the npc event state
   if unit_number == 1 then
    event = update_belossom()
   else
    -- default
   end

   self.timer += 1
   self.event = event
  end,

  move = function(self)
   -- npc state
   local x = self.x
   local y = self.y
   local timer = self.timer
   local unit_number = self.unit_number
   local event = self.event

   -- only move relevant units
   if unit_number == 0 then
    -- this is the default unit, it does nothing
   end

   -- update location
   self.x = x
   self.y = y
  end,

  draw = function(self)
   -- npc state
   local x = self.x
   local y = self.y
   local timer = self.timer
   local unit_number = self.unit_number
   local event = self.event

   if unit_number == 1 then
    self.timer = draw_belossom(x, y, timer)
   else
    -- default
   end
  end
  })
end

function update_belossom()
 -- belossom has no events at the moment
 return 0
end

function draw_belossom(x, y, timer, event)
 local sprite = 33
 local hmirror = false
 
 -- sometimes belossom can turn around
 if event == 1 then
  hmirror = true
 end

 -- belossom dances
 if timer < 12 then
  sprite = 33
 elseif timer < 24 then
  sprite = 35
 elseif timer < 36 then
  sprite = 37
 elseif timer < 48 then
  sprite = 35
 else
  timer = 0
 end

 spr(sprite, x, y, 2, 2, hmirror)

 return timer
end


__gfx__
000000000000000000bbbb0000bbbb00000000000bbb00000bbb000000000000000000000000000000000000000001000000000000c000000000a00000000000
0000000000bbbb000bbbebb00bbbebb000000000bbbbe000bbbbe0000000f00000000000c500500000000500001110000003333000cc0000000aaa0000000000
007007000bbbebb00b3efe700b3efe7000bbbb00bbbef000bbbef000555fff55000440000566600000057550011111000033bb330cccc000009aaa0aa0000000
000770000b3efe700773e7700773e7700bbbebb0bbb3e000bbb3e000055fff50004444008677665c0010707511111110033b30000cccc0000a09a999a0000000
000770000773e77070000700007007000b3efeb0bbbb3000bbbb300005fefef0004ee4000607665000599775110111103b333333cccccc00aa9898899aa00000
007007000700070000000000000000700bb3ebb00bbb00000bbb000000fffff000444400006660580555115111101150033b3330c7c77cc0098a8aa89aa00000
0000000000000000000000000000000000000000000000000707000000fffff00054445000050000155177500151155500133300717177c009a0a0aa90000000
0000000000000000000000000000000000000000000000000000000000f00f000555455500000000001919900005555501111110c7c77cc0aa8a8aa8aa000000
000000000000000000000000000000000000000007777700000000000000000000000000000a00000000000001005150118181110ccccc0000a8889aa0000000
000000000000000000bbbb0000bbbb0000bbbb0077777770000000000004030000000000a0aaa0a000aaa000150505101e111e11076665500079997600700000
00bbbb0000bbbb000bbbebb00bbbebb00bbbebb0777777700077700000843000011000100a0a0a000aaaaa009555559001111110766766550676676667000000
0bbbebb00bbbebb00b3efeb00b3efeb00b3efe70777777700777770008ff880001111110afaaafa00a7aa7000509050500011000076766650667676660000000
0b3efeb00b3efeb00bb3eb700773e7700773e77007777700077770000888880001ffff1007a77a70777777705f676f5000111000005076500060607600000000
0bb3ebb00bb3eb700b0007000700070007000700000770000070000008888800100ff001a777787a777778705666665500000000000000000000000000000000
00000000000000000000000000000000000000000000770000007000008480001effffe177177770771777700566656600000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000111111110a717a0007717700f000f00f00000000000000000000000000000000
000033000000008800000000000000000000000000000000008000000000000000000000000d0000d00000000000000000001000010000000000006000000000
0003b330000008a880800000000000880080000000000080088800000000000000b0b00000060000d00000000011110177700100100077700666660000000000
003b300000000b88b8880000000008a8888800000000888888a8800000b0b00000bb000000600606d00000000111111077779909900777700660000566000000
303b3003000000fbb8a800000000008bb8a88000000008a8b88b00b000bb00000888800060d0d06d00000000011111117777aa9aa97777707665505666000000
bb33b333000000bbfb880000000000bfbb8800000000088bbfb00bb008888000888888000dd00dd000000000010111110777aa9aa98777007666666666000000
03b333300000000bbbb000000000000bbfbb0000000000bfbbb3bb00888888008000880000d6776d0000000001101151000099a9919900000076d66660000000
00111100000000bb3b0000000000000bbbb000000000000bbb3000008a8a88300a0a80000d666676d0000000005115550000a1a1a1900000000d7d77dd000000
011111100000bb03bb3000000000000b3bbb000000000000bbbb00000aaaa3030aaaa333b60660db6d0000000105555500000aaa99000000000707077d500000
1181811100000aabb3300000000000a3b30bb000000000aa33bba0000780007800000f0fdbdd6dbbb5000000001000510000100001000000066d7d77d6560000
1e111e110a0aa33bb33a000000000aa3bb33b00000000aa33333aa0008870077000000ff0d5dd5db3d0000000505511000000100100000000766ddd665660000
0111111000aa3333333a0000000aaa33bb333a000000aaa333333aa00078088000000fff00d556dd600000000555559000009909900000000066666766600000
001001000aa333a333aa00000000a333a3333aa00000aa333a333aa000007700000f3fff0dd6ddd6d66dd000059055050077aa9aa97770000007655776000000
0110110030333aa333aaa000000aa333aa3333a0000aaa33aaa333aaa0aaa00000ff5555dddddddddddd0000f676f5500777aa9aa98777000000066550000000
0000000000030aa333aaa0000030033aaa3333a000030333aaa333030aaaaaa00f33ffff00d00dd60000000066666650777799a9919777700000006600000000
0000000000000030303a000000000303a3033030000000303a3030000aaa0a000f3f555f0000000000000000056656657770a1a1a19077700000000600000000
0000000000000000000000000000000000000000000000000000000000aaa000ffffffff000000000000000000ff0f5000000aaa990000000000000000000000
33333333444444443333333344444444333333333333333300030000333bb3330000000000000000000000000000000000000000000000000000000000000000
4344434445444454443443344444444444444444443443340003a000443433340000000000000000000000000000000000000000000000000000000000000000
43444334444544444434434444444444444444440030430000330000000b90000000000000000000000000000000000000000000000000000000000000000000
43344434444444444444334445444444444444440000330000930000000030000000000000000000000000000000000000000000000000000000000000000000
4344443454455454444434444444445444444444000030000003b0000003b0000000000000000000000000000000000000000000000000000000000000000000
44444444444444544444444444444454445444440000000000033000000300000000000000000000000000000000000000000000000000000000000000000000
44445444445444444444444444444444444444440000000000b30000000930000000000000000000000000000000000000000000000000000000000000000000
44444444444544444454444444454444444444440000000000030000000330000000000000000000000000000000000000000000000000000000000000000000
44444444445555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444555554550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444455555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444545555540000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444555545550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000777000110000000111000000000f0f0f00000000ff0000000000000000117711000000000001177100000
00000000000000000000000000000000000000000077777001c1100011c100000000000fff00000000fff0000000000000011177711111000000011177700000
0110000000111000000000000000000000000000077776600011c101c1100000000000ffff30000000ff50000000000000771177771177111117711777710700
01c1100011c10000000000000000000000000000777677600000111c100000000000f3555ff3500000f5f000f000000007777fffff1777711177771ffff17770
0011c101c110000000000000000000000000000067777770000001c111000000000ff5f5fffff5000f00fffff00000000777fffffffff77111777ffffffff770
0000111c100000000000000000000000000007706767776000001cccc110000000f33fffffff3f500f00fcfcf0000000007fffffffffff711117ffffffffff70
000001c11100000000000000000000000000770777766670001cc7ccccc1000000f3f555fff33350f0000fff00000000000fffffffffff71111fffffffffff70
00071cccc11067600000077067770000000667777776570000107770cccc10000fffffffffff3ff0fff0055000ff000000ffff5555fffff1111ffff5555fff00
071cc7ccccc177760000770777777770006776777765670001cc777cfcccc100fff5fff5ffff55ff0000ffff0f0ff00000fff555555ffff1111fff555555fff0
671c777ccccc10070006677777777777777777667776600001ccc7ccccccc1000f5fff51fff51155000f0ff5f000f00000ff5555555ffff1111fff5555555ff0
710077700cccc16570677677776777777677766566565000001ccccccccc1000000ff5113f5130000000ffff500ff00001ff55555555fff1111ff55555555ff0
71ccc7ccfcccc17677777766777677670767665655650000001cccccccccc10000000333313300000000f5ffff5f000011ff55555555fff1111ff55555555ff0
7017ccccc7777777767776656656567700565565550000000001cccc161ccc0000003330003330000000ff00ff00000011ff55555555fff1111ff55555555ff0
077777cc7777766707676656556500660000055000000000000060110601cc10000000000000000000000f0000f00000111ff555555ffff1111fff555555ff10
5677777c777765660056556555000000000000000000000000000000000011c1000000000000000000000f0000f00000111fff5555ffff111111fff5555ff111
0566775167665515000005500000000000000000000000000000000000000011000000000000000000000000000000006111fffffffff11111111fffffff1116
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010100000000000000000000000000010101010081818181818102830000000000000000810000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000045454547450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000046000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000454745000000000000000000000000006c6d6e6f00000046000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000004600000000000000000000000000007c7d7e7f00000046000042000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4240444044404244404042004640404440424444424040424440514442424044424446000043000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4343434343434343434343444443434343434343434341515151515151515151515146000041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4343414341434343434343434143434343434343434343434343434343434343434343434343000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4141414141414141414141414141414141414141414141414141414141414141434343434141000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000420000000000000000000000000000440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000420000000000000000000000000000440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000420000000000000000000000000000440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000420000000000000000000000000000440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000444545454545454545454545454745440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000440000000000000000000000004600440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000440000000000000000000000004600440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000444444444444444444444444444444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000200000d01116060120600d06004060000600100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000e00003a024320222e0222c0523a0523a0523a0523a055331003210032100321003210032100311003010000000000000000000000000000000000000000000000000001000010000100000000000000000000
010300000a7140d721117311b74126713005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
012a00003803431032330323303500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
019000000f6340f6320f6320f6350f6340f6310f6320f6320f6350f6340f6320f6310f6350f6340f6350f6340f6320f6320f6310f6310f6350f6340f6310f6350f6340f6320f6350f6340f6310f6310f6350f634
019000000f6140f6120f6120f6150f6140f6110f6120f6120f6150f6140f6120f6110f6150f6140f6150f6140f6120f6120f6110f6110f6150f6140f6110f6150f6140f6120f6150f6140f6110f6110f6150f614
__music__
00 00014344

