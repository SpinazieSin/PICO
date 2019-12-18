pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- 0
function reset()
 reset_round()
 lives = 3
end

function reset_round()
 x=1
 dx=1
 y=50
 dy=1 
 ball_r = 2
 pad_x = 60
 pad_dx = 0
 pad_y = 122
 pad_width = 4
 xcol = false
 ycol = false
end

-- 1
function _init()
 cls()
 reset()
 mode="s"
end

-- 2
function _update60()
 if mode=="g" then
  update_game()
 elseif mode=="o" then
  update_game_over()
 elseif mode =="s" then
  update_start()
 end
end

-- 3
function _draw()
 if mode=="g" then
  draw_game()
 elseif mode=="o" then
  draw_game_over()
 elseif mode =="s" then
  draw_start()
 end
end

function update_game()
 get_input()

 if x > 123 or x < 0 then
  dx = -dx
  sfx(0)
 end
 if y < 0 or y > 124 then
  dy = -dy
  sfx(0)
 end

 local col = false
 if b_ycol(x, y) then
  dy = -dy
  col = true
 end
 if b_xcol(x, y) then
  dx = -dx
  col = true
 end
-- if col then
--  if pget(4,4) > 1 then
--   x-=1
--   y-=1
--  elseif pget(1,4) > 1 then
--   x+=1
--   y-=1
--  elseif pget(1,1) > 1 then
--   x+=1
--   y+=1
--  elseif pget(4,1) > 1 then
--   x-=1
--   y+=1
--  end
-- end

 x+=dx
 y+=dy
 
 -- check death
-- if y > 124 then
--  reset_round()
--  lives-=1
--  if lives == 0 then
--   mode="o"
--  end
-- end
end

function update_game_over()
 if btn(5) then
  mode="s"
 end
end

function update_start()
 if btn(5) then
  mode="g"
 end
end

function draw_game()
 cls(1)
 sspr(8, 0, 16, 4, pad_x, pad_y)
 spr(3, x, y)
 rectfill(0, 0, 127, 6, 14)
 print("♥:"..lives, 1, 1, 7)
end

function draw_game_over()
 cls(8)
 print("★dead★", 50, 63, 0)
end

function draw_start()
 cls(14)
 print("★", 61, 63)
 print("press ❎ to start", 33, 80)
end 
 
-- 4
function get_input()
 b_pres = false
 if btn(0) and pad_dx > -4 then
  pad_dx-= 1
  b_pres = true
 end
 if btn(1) and pad_dx < 4 then
  pad_dx+= 1
  b_pres = true
 end
 if not(b_pres) then
  pad_dx = 0
 end
 pad_x+=pad_dx
end

--5
function b_ycol(x, y)
 if pget(x+1, y) > 1 or pget(x+4, y) > 1 or pget(x+1, y+5) > 1 or pget(x+4, y+5) > 1 then
  return true
 end
 return false
end

--6
function b_xcol(x, y)
 if pget(x, y+1) > 1 or pget(x, y+4) > 1 or pget(x+5, y+1) > 1 or pget(x+5, y+4) > 1 then
  return true
 end
 return false
end

__gfx__
00000000aaaaaaaaaaaaaaaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000777777777777777700990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700aaaaaaaaaaaaaaaa09aa9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000009aa9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000a7000c7000c7000c7000d7000f7000f7001070011700127000a7100e7401177013770137701377013770107700a7700a7701677017770197501a7301b72015700157001470014700127001170011700
