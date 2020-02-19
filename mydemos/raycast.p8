pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function _init()
	posx, posy = 10, 10
	dirx, diry = 1, 1
	planex, planey = 0, 0.66
 movespeed, rotspeed = 0.5, 0.01
	
 h = 127
 w = 127
end

function _update()
 if btn(2) then
  if mget((posx + dirx * movespeed)/8, posy/8) < 1 then
   posx += dirx * movespeed
  end
  if mget(posx/8, (posy + diry * movespeed)/8) < 1 then
   posy += diry * movespeed
  end
 elseif btn(3) then
  if mget((posx - dirx * movespeed)/8, posy/8) < 1 then
   posx -= dirx * movespeed
  end
  if mget(posx/8, (posy - diry * movespeed)/8) < 1 then
   posy -= diry * movespeed
  end
 end

 if btn(0) then
  olddirx = dirx
  dirx = dirx * cos(rotspeed) - diry * sin(rotspeed)
  diry = olddirx * sin(rotspeed) + diry * cos(rotspeed)
  oldplanex = planex
  planex = planex * cos(rotspeed) - planey * sin(rotspeed)
  planey = oldplanex * sin(rotspeed) + planey * cos(rotspeed)
 elseif btn(1) then
  olddirx = dirx
  dirx = dirx * cos(-rotspeed) - diry * sin(-rotspeed)
  diry = olddirx * sin(-rotspeed) + diry * cos(-rotspeed)
  oldplanex = planex
  planex = planex * cos(-rotspeed) - planey * sin(-rotspeed)
  planey = oldplanex * sin(-rotspeed) + planey * cos(-rotspeed)
 end
end

function _draw()
 cls()
 draw3d()
 oldtime = gt
 gt = time()
 print("mem: "..stat(0))
 print("cpu: "..stat(1))
end

function draw3d()
 for x=0,127 do
  camerax = 2 * (x / 127) - 1
  
  raydirx = dirx + planex * camerax
  raydiry = diry + planey * camerax

  mapx = posx
  mapy = posy

  deltadistx = abs(1 / raydirx)
  deltadisty = abs(1 / raydiry)

  -- step direction
  stepx = 0
  stepy = 0

  wallhit = false
  side = 0

  if raydirx < 0 then
   stepx = -1
   sidedistx = (posx - mapx) * deltadistx
  else
   stepx = 1
   sidedistx = (mapx + 1 - posx) * deltadistx
  end
  if raydiry < 0 then
   stepy = -1
   sidedisty = (posy - mapy) * deltadisty
  else
   stepy = 1
   sidedisty = (mapy + 1 - posy) * deltadisty
  end

  wallcolor = 8
  while not(wallhit) do
   if sidedistx < sidedisty then
    sidedistx += deltadistx
    mapx += stepx
    side = 0
   else
    sidedisty += deltadisty
    mapy += stepy
    side = 1
   end
   if mget(mapx/8, mapy/8) > 0 then
    wallhit = true
    wallcolor = mget(mapx/8, mapy/8)
   end
  end
  
  if side == 0 then
   perpwalldist = (mapx - posx + (1 - stepx) / 2) / raydirx
  else
   perpwalldist = (mapy - posy + (1 - stepy) / 2) / raydiry
  end

  lineheight = (h / perpwalldist)
  drawstart = -lineheight / 2 + h / 2
  if drawstart < 0 then
   drawstart = 0
  end
  drawend = lineheight / 2 + h / 2
  if drawend >= h then
   drawend = h - 1
  end

  -- wallcolor = 8

  -- if side == 1 then
  --  wallcolor = 7
  -- end

  line(x, drawstart, x, drawend, wallcolor)
 end
end

__gfx__
00000000111111112222222233333333444444445555555566666666777777778888888899999999aaaaaaaabbbbbbbbccccccccddddddddeeeeeeeeffffffff
00000000111111112222222233333333444444445555555566666666777777778888888899999999aaaaaaaabbbbbbbbccccccccddddddddeeeeeeeeffffffff
00700700111111112222222233333333444444445555555566666666777777778888888899999999aaaaaaaabbbbbbbbccccccccddddddddeeeeeeeeffffffff
00077000111111112222222233333333444444445555555566666666777777778888888899999999aaaaaaaabbbbbbbbccccccccddddddddeeeeeeeeffffffff
00077000111111112222222233333333444444445555555566666666777777778888888899999999aaaaaaaabbbbbbbbccccccccddddddddeeeeeeeeffffffff
00700700111111112222222233333333444444445555555566666666777777778888888899999999aaaaaaaabbbbbbbbccccccccddddddddeeeeeeeeffffffff
00000000111111112222222233333333444444445555555566666666777777778888888899999999aaaaaaaabbbbbbbbccccccccddddddddeeeeeeeeffffffff
00000000111111112222222233333333444444445555555566666666777777778888888899999999aaaaaaaabbbbbbbbccccccccddddddddeeeeeeeeffffffff
__map__
010101010101010101010101010606060606060606060404040404040f0e0d0c0b0a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000100000000000106000000000000000604000000000400000000000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000100000000000106000000000000000000000000000400000000000900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000106000000000000000000000000000400000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000100000000000106000000000000000604000000000400000000000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000100000000000106060600000606060604040404040400000000000e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010000010101010101010105050500000505050508000000000000000000000d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000010000000105000000000000000509000000000000000000000c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010000000000000001000000010500000000000000050a000000000000000000000b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010000000000000001000000010500000000000000050b000000000000000000000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010000000000000001000000010500000000000000050c000000000000000000000900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010000000000000001000000010500000000000000050d000000000000000000000f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01010101010101000101010101050505000005050505080e0f0908090a0b0c0d0e0800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000303030300030300000000000000000500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000300000000000300000001050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000300000000000300000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000300000000000300000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000300000303030300000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000200000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000200000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000200000000000200000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000202020202020201010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
