pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
function _init()
	plr_x = 133
	plr_y = 75
	sprint_speed = 1

--sprite animations init
	ani_water=1
	ani_plr=64
--adjust colors to new pallete
	poke(0x5f2e, 1)
	for i in all({1,3,5,6,11,12,15}) do
		pal(i, 128+i, 1)
	end
	
	wall_id = 1
end

function _update()
--camera controls
	plr_dx = 0
	plr_dy = 0
	
	if btn(4) then
		sprint_speed += 1
		wall_id = 0
	end
	if btn(5) and not(sprint_speed < 2) then
		sprint_speed -= 1
		wall_id = 1
	end
	if btn(0) and not(plr_col(-1, 0) or plr_col(-1, 4) or plr_col(-1,7)) then
		plr_x -= sprint_speed
	end
	if btn(1) and not(plr_col(8, 0) or plr_col(8, 4) or plr_col(8,7)) then
		plr_x += sprint_speed
	end
	if btn(2) and not(plr_col(0, -1) or plr_col(4, -1) or plr_col(7,-1)) then 
		plr_y -= sprint_speed
	end
	if btn(3) and not(plr_col(0, 8) or plr_col(4, 8) or plr_col(7,8)) then
		plr_y += sprint_speed
	end
	camera(plr_x-63, plr_y-63)
--sprite animations
	ani_water+=0.0625
	if ani_water > 2.9 then
			ani_water=1
	end
	ani_plr+=0.0625
	if ani_plr > 65.9 then
			ani_plr=64
	end
end

function _draw()
	cls()	
	map(0, 0, 0, 0, 128, 128)
	spr(ani_plr, plr_x, plr_y)	
end
-->8
function plr_col(x, y)
	return (fget(mget((plr_x+x)/8, (plr_y+y)/8), wall_id))
end
__gfx__
00010000000010000000000000710cc1000001b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001c10000011b1100000b000000b10c1001111b10100001010000001000000000000000000000000000000000000000000000000000000000000000000000000
01b7c10000100010000101001111b0c101bbbbb10c0000c00c7dd7c0000000000000000000000000000000000000000000000000000000000000000000000000
1bbbcc1001b070b1001070101bbbbcc101bccc11007dd70000e11e00000000000000000000000000000000000000000000000000000000000000000000000000
bb7c7cc0001000100b07070b1bbcccc101b77c1000e11e0000cccc00000000000000000000000000000000000000000000000000000000000000000000000000
bbb1ccc00011b110011111111b0c111111bbbc100cccccc000c00c00000000000000000000000000000000000000000000000000000000000000000000000000
1b101c1000001000000010001b01c0001ccccc10cc0000cc0cc00cc0000000000000000000000000000000000000000000000000000000000000000000000000
0100010000000000000000001bb017000c1111001100001101100110000000000000000000000000000000000000000000000000000000000000000000000000
