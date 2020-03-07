pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function _init()	
	sqrt_2 = sqrt(2)/2
	
	objs = {}
	pcls = {}
 enms = {}

	add_player()
	
 -- globals
	gbl = {ghost = false,
								ghostx = 0,
								ghosty = 0,
								ghostt = 0
								}
	
	gt = 0
	plr_x = 1
	plr_y = 1
	cam_shake = false
	cam_offset=0
	cam_dx = 0
	cam_dy = 0
end

function _update()
 gt += 1
	plr = objs[1]

	local ghostt = gbl.ghostt 
	if (btn(5)) and ghostt == 0 then
		if not(gbl.ghost) then
			for _=1,20 do
				add_particle(flr(rnd(1.99)+1), plr.x+5, plr.y+4)
			end
			add_ghost(plr.x, plr.y)
			for i=1,15 do
				pal(i, 128+i, 1)
			end
		end
		gbl.ghost = true
	else
		if gbl.ghost then
			cam_offset = 1.2
			for i=1,16 do
				pal(128+i, i, 1)
			end
			gbl.ghostt = 90
			for _=1,20 do
				add_particle(flr(rnd(2)+7), gbl.ghostx+5, gbl.ghosty+4)
			end
		end
		gbl.ghost = false
	end
	if (ghostt > 0) gbl.ghostt -= 1

	if flr(gt+rnd(1))%90 == 0 then
		local spawn_x = 63+sgn(rnd(2)-1)*(30+rnd(34))
		local spawn_y = 63+sgn(rnd(2)-1)*(30+rnd(34))
		for _=1, 10 do
			add_particle(flr(rnd(9)+2), spawn_x, spawn_y)
		end
		add_enemy(spawn_x, spawn_y)
	end

 for enm in all(enms) do
  enm:update()
 end
	for obj in all(objs) do
		obj:update()
	end
	for pcl in all(pcls) do
		pcl:update()
	end
	
	if (cam_offset > 0.04) screen_shake()
	camera(plr_x-63+cam_dx, plr_y-63+cam_dy)
end

function _draw()
	cls()
	
 for enm in all(enms) do
  enm:draw()
 end
	for obj in all(objs) do
		obj:draw()
	end
	for pcl in all(pcls) do
		pcl:draw()
	end
end
-->8

function add_player()
 x = x or 1
 y = y or 1
	add(objs, {
		x = x,
		y = y,
		draw = function(self, x, y, n)
			x = x or self.x
			y = y or self.y
			if gbl.ghost then
				n = 0
			elseif gbl.ghostt > 0 then
				n = 16
			else
				n = 1
			end
			spr(n, x, y)
		end,
		update = function(self)
			if not(gbl.ghost) then
				if (btn(0)) self.x -= 1
				if (btn(1)) self.x += 1
				if (btn(2)) self.y -= 1
				if (btn(3)) self.y += 1
			end
			plr_x = self.x
			plr_y = self.y
		end
		})
end

function add_particle(clr, x, y, r, dx, dy, lifespan)
	clr = clr or flr(rnd(16))
	x = x or 63
	y = y or 63
	r = r or flr(rnd(2.9))+1
	dx = dx or rnd(3)-1.5
	dy = dy or rnd(3)-1.5
	lifespan = lifespan or rnd(5)+5
	add(pcls, {
		x = x,
		y = y,
		r = r,
		dx = dx,
		dy = dy,
		life = lifespan,
		draw = function(self, x, y)
			x = x or self.x
			y = y or self.y
			circfill(x, y, self.r, clr)
		end,
		update = function(self)
			self.x += self.dx
			self.y += self.dy
			self.r -= 0.2
			self.life -= 1
			if self.life < 0 then
				self.dx = self.dx/1.5
				self.dy = self.dy/1.5
			end
			if abs(self.dx) < 0.05 and abs(self.dy) < 0.05 then
				del(pcls, self)
			end
		end})
end

function add_ghost(x, y)
 x = x or 1
 y = y or 1
	add(objs, {
		x = x,
		y = y,
		draw = function(self, x, y)
			x = x or self.x
			y = y or self.y
			spr(3, x, y)
		end,
		update = function(self)
			if not(gbl.ghost) then
				objs[1].x = self.x
				objs[1].y = self.y
				del(objs, self)
			else
				if (btn(0)) self.x -= 2
				if (btn(1)) self.x += 2
				if (btn(2)) self.y -= 2
				if (btn(3)) self.y += 2
				gbl.ghostx = self.x
				gbl.ghosty = self.y
			
				for enm in all(enms) do
					if enm.distx < 10 and enm.disty < 10 then
						enm.possessed = true
						del(objs, self)
						break
				end
				end
			end
		end
		})
end

function add_enemy(x, y)
	x = x or 126
	y = y or 126
	add(enms, {
						x = x,
						y = y,
						dx = 1,
						dy = 1,
						possessed = false,
						dead = false,
						draw = function(self)
							local n = 4
							if (self.possessed) n = 5
							spr(n, self.x, self.y)
						end,
						update = function(self)
							local dead = self.dead
							if self.possessed then
								if not(gbl.ghost) then
									local selfx = self.x
									local selfy = self.y
									objs[1].x = selfx
									objs[1].y = selfy
									del(enms, self)
									for enm in all(enms) do
										local distx = abs(enm.x - selfx)
										local disty = abs(enm.y - selfy)
										if (distx < 15 and disty < 15) enm.dead = true
									end
									dead = true
								else
									if (btn(0)) self.x -= 1
									if (btn(1)) self.x += 1
									if (btn(2)) self.y -= 1
									if (btn(3)) self.y += 1
									gbl.ghostx = self.x
									gbl.ghosty = self.y
								end
							else
								local distx = self.x - plr_x
								local disty = self.y - plr_y
								if gbl.ghost then
									self.distx = abs(gbl.ghostx - self.x)
									self.disty = abs(gbl.ghosty - self.y)
								end
								if abs(distx) > 1 and abs(disty) > 1 then
									self.x -= sgn(distx)*sqrt_2
									self.y -= sgn(disty)*sqrt_2
								elseif abs(distx) < 2 then
									self.y -= sgn(disty)
								else
									self.x -= sgn(distx)
								end
							end
							if dead then
								local prt_x = self.x + 4
								local prt_y = self.y + 4
								for _=1,3 do
									add_particle(8, prt_x, prt_y )
									add_particle(13, prt_x, prt_y)
								end
								for _=1,2 do
									add_particle(13, prt_x, prt_y)
								end
							 del(enms, self)
							end
						end})
end
-->8

function screen_shake()
  local fade = 0.5
		cam_dx=4-rnd(8)
		cam_dx=4-rnd(8)
  cam_dx*=cam_offset
  cam_dy*=cam_offset
  cam_offset*=fade
  if cam_offset<0.05 then
    cam_offset=0
  end
end

__gfx__
00000000000000000000000000088880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000666600000000000822220000888800008888000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000069979000066660080122200087dd780087887800000000000000000000000000000000000000000000000000000000000000000000000000000000
0006666006019990066997900001d11000dcddcd002c22c200000000000000000000000000000000000000000000000000000000000000000000000000000000
006999900001d110000199900001111000dcddcd002c22c200000000000000000000000000000000000000000000000000000000000000000000000000000000
06019990000111100001d1100001111000dcddcd002c22c200000000000000000000000000000000000000000000000000000000000000000000000000000000
0001d110000001000001111000111100000dddd00002222000000000000000000000000000000000000000000000000000000000000000000000000000000000
000111110000010000001010011110000000dd000000220000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00066660006666600000000000eee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0062272000979790006666600eeeee00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
060122200099999000979790ee1e1ee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0001d11000d111d000999990e81e18ee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000111100011111000d111d00eeeeeee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000100000101000011111088eee880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000100000101000001010088808880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0808080808080000000000000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
