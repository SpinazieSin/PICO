pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- 0
function reset()
 reset_round()
 lives = 3
 boom = 10
 power = 999
 dpower = 1
 power_color = 7
end

-- 1
function reset_round()
 x=1
 dx=1
 y=50
 dy=1
 ball_r = 2
 pad_x = 60
 pad_dx = 0
 pad_y = 110
 pad_dy = 0
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
-- 	draw_test()
  draw_start()
 end
end

-- 4
function update_game()
	move_ball()

 move_paddle()

 check_death()
end

-- 5
function update_game_over()
 if btn(5) then
  mode="s"
 end
end

-- 6
function update_start()
 if btn(5) then
  mode="g"
 end
end

-- 7
function draw_game()
 cls(1)
 sspr(8, 0, 16, 4, pad_x, pad_y)
 if btn(4) and power > 0 then
 	draw_boom()
 	power -= dpower
 	power_color = boom
 else
 	boom = 10
 	power_color = 7
 end
	spr(3, x, y)
 

	if brick_v then 
 	rectfill(brick_x, brick_y, brick_x+brick_w, brick_y+brick_h, brick_c)
 end
 
 rectfill(0, 0, 127, 6, 14)
 print("♥:"..lives, 1, 1, 7)
 print("✽:", 100, 1, 7)
 print(power, 112, 1, power_color)
end

--8
function draw_game_over()
 cls(8)
 print("★dead★", 50, 63, 0)
end

-- 9
function draw_start()
 cls(14)
 print("★", 61, 63)
 print("press ❎ to start", 33, 80)
end 
 
-- 10
function move_paddle()
 b_pres = false
 if btn(0) and pad_dx > -4 then
  pad_dx-= 1
  b_pres = true
 end
 if btn(1) and pad_dx < 4 then
  pad_dx+= 1
  b_pres = true
 end
 if btn(2) and pad_dy > -2 then
 	pad_dy-= 1
 	b_pres = true
 end
 if btn(3) and pad_dy < 2 then
 	pad_dy+= 1
 	b_pres = true
 end
 
 if not(b_pres) then
  pad_dx = 0
  pad_dy = 0
 end
 pad_x+=pad_dx
 pad_y+=pad_dy
 pad_x = mid(0, pad_x, 112)
 pad_y = mid(100, pad_y, 125)
end

-- 11
function b_ycol(x, y)
 if pget(x+1, y) > 1 or pget(x+4, y) > 1 or pget(x+1, y+5) > 1 or pget(x+4, y+5) > 1 then
  return true
 end
 return false
end

-- 12
function b_xcol(x, y)
 if pget(x, y+1) > 1 or pget(x, y+4) > 1 or pget(x+5, y+1) > 1 or pget(x+5, y+4) > 1 then
  return true
 end
 return false
end

-- 13
function move_ball()
if x > 123 or x < 0 then
  dx = -dx
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
 
 if col then
  if pget(x+4,y+4) > 1 then
   x-=2
   y-=2
  elseif pget(x+1,y+4) > 1 then
   x+=2
   y-=2
  elseif pget(x+1,y+1) > 1 then
   x+=2
   y+=2
  elseif pget(x+4,y+1) > 1 then
   x-=2
   y+=2
  end
 end

 x+=dx
 y+=dy
end

-- 14
function check_death()
 if y > 124 then
  reset_round()
  lives-=1
  if lives == 0 then
			mode="o"
  end
 end
end

-- 15
function spawn_bricks()
	bx_offset = 10
	by_offset = 10
	
 brick_x = {}
 brick_y = {}
 brick_w = {}
 brick_h = {}
 brick_c = {}
 brick_v = true
 local i
 for i=1,5 do
 	brick_x[1] = 5
 end
end

function draw_boom()
	boom_x = {32, 40, 57}
	boom_w = {8, 10, 14}
	boom_o = {1, 2, 4}
	exploding = false
	if not(exploding) and btn(4) then
		exploding = true
	end
	if exploding then
		local i = flr(boom/10)
		sspr(boom_x[i],0,boom_w[i], boom_w[i], x-boom_o[i], y-boom_o[i])
		boom += 1
	end
	if boom == 39 then
		boom = 10
		exploding = false
	end
end
__gfx__
00000000aaaaaaaaaaaaaaaa00000000008888000007777000000000000000088000000009000000000000000000000000000000000000000000000000000000
0000000077777777777777770099000007000070008000080000000000000880088000009a000000000000000000000000000000000000000000000000000000
00700700aaaaaaaaaaaaaaaa09aa900080099008080000008000000000007000000700009a000000000000000000000000000000000000000000000000000000
00077000000000000000000009aa9000809aa9087000990007000000000700000000700009000000000000000000000000000000000000000000000000000000
00077000000000000000000000990000809aa9087009aa9007000000008000000000080000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000800990087009aa9007000000008000099000080000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000700007070009900070000000800009aa900008000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000088880008000000800000000800009aa900008000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000080000800000000008000099000080000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000007777000000000008000000000080000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000700000000700000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000070000007000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000008800880000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000a7000c7000c7000c7000d7000f7000f7001070011700127000a7700e7401177013770137701377013770107700a7700a7701677017770197501a7301b72015700157001470014700127001170011700
000200002e05034050370501a050090500105000050180001f0002100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
