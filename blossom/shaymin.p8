pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- main functions --
function _init()
 -- gametime
 gt = 0
 
 -- shaymin variables
 sprite = 1
 sx, sy = 20, 63
 left, jump, up, vine = false, false, false, false

	-- flower and branch colors
	flwrcols = {7, 8, 9, 10, 14}
	brnchcols = {3, 11}
	flowers = {}
end

function _update()
 -- increment gametime
 gt += 1
 
 -- move shaymin
 getmovement()

 -- falling
 if not(fget(mget((sx+1)/8, (sy+6)/8), 0) or fget(mget((sx+6)/8, (sy+6)/8), 0)) and not(vine or up) then
  sy += 1
  sprite = 3
 elseif not(jump or vine) then
  sprite = 1
 end
 
 for flwr in all(flowers) do
 	flwr:update()
 end
end

function _draw()
 cls(12)
 map()
 
 for flwr in all(flowers) do
 	flwr:draw()
 end

 local hmirror = false
 if left and not(sprite > 4) then
  hmirror = true
 end
 spr(sprite, sx, sy, 1, 1, hmirror) 
end

-->8
-- movement functions --
function getmovement()

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

-->8
-- particles --
function add_flower(x, y)
 -- random chance to spawn flower
 if (rnd(100) < 80) return

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
   line(self.x, self.y, self.x, self.y - self.h, self.brnch)
   if self.bloom then
    circfill(self.x, self.y - self.h, self.bloom_size, self.flwr)
   end
		end
	})
end

__gfx__
000000000000000000bbbb0000bbbb00000000000bbb00000bbb0000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000bbbb000bbbebb00bbbebb00bbb0000bbbbe000bbbbe000000000000000000000000000000000000000000000000000000000000000000000000000
007007000bbbebb00b3efe700b3efe70bbbbe000bbbef000bbbef000000000000000000000000000000000000000000000000000000000000000000000000000
000770000b3efe700773e7700773e770bbbef000bbb3e000bbb3e000000000000000000000000000000000000000000000000000000000000000000000000000
000770000773e7707000070000700700bbb3e000bbbb3000bbbb3000000000000000000000000000000000000000000000000000000000000000000000000000
00700700070007000000000000000070bbbb30000bbb00000bbb0000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000bbb00000000000007070000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
33333333444444443333333344444444333333333333333300030000333bb3330000000000000000000000000000000000000000000000000000000000000000
4344434445444454443443344444444444444444443443340003a000443433340000000000000000000000000000000000000000000000000000000000000000
43444334444544444434434444444444444444440030430000330000000b90000000000000000000000000000000000000000000000000000000000000000000
43344434444444444444334445444444444444440000330000930000000030000000000000000000000000000000000000000000000000000000000000000000
4344443454455454444434444444445444444444000030000003b0000003b0000000000000000000000000000000000000000000000000000000000000000000
44444444444444544444444444444454445444440000000000033000000300000000000000000000000000000000000000000000000000000000000000000000
44445444445444444444444444444444444444440000000000b30000000930000000000000000000000000000000000000000000000000000000000000000000
44444444444544444454444444454444444444440000000000030000000330000000000000000000000000000000000000000000000000000000000000000000
44444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000100010102030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000454745000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000004600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4240444044404244404042004640404400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4343434343434343434343444443434300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4343414341434343434343414143434100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4141414141414141414141414141414100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
