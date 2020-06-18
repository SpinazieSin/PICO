pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
function _init()
	plr_x = 63
	plr_y = 60
	sprint_speed = 1
--	gt = 0

--sprite animations init
		ani_plr=0
-- particle effect list init
		pcls = {}
--adjust colors to new pallete
--	poke(0x5f2e, 1)
--	for i in all({1,3,5,6,11,12,15}) do
--		pal(i, 128+i, 1)
--	end
end

function _update()
--camera controls
	plr_dx = 0
	plr_dy = 0
	camera(plr_x-63, plr_y-63)
--	gt += 1
	if rnd(1) < 0.02 then
		for _=1,3 do
		add_particle( flr(rnd(16)), rnd(128), rnd(128),1,0.01,0,rnd(200))
		add_particle( flr(rnd(16)), rnd(128), rnd(128),1,-0.01,0,rnd(200))
		end
	end
	
	for pcl in all(pcls) do
		pcl:update()
	end
end

function _draw()
	cls(1)	
	map(0, 0, 0, 0, 128, 128)
	for pcl in all(pcls) do
		pcl:draw()
	end
	spr(ani_plr, plr_x, plr_y, 2, 2)
	spr(2, plr_x+4, plr_y+3)	
	print("mem:"..stat(0),4,4)
	print("cpu:"..stat(1),4,10)
end


-->8
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
			self.r -= 0.0--2
			self.life -= 1
			if self.life < 0 then
				self.dx = self.dx/1.5
				self.dy = self.dy/1.5
			end
			if abs(self.dx) < 0.005 and abs(self.dy) < 0.005 then
				del(pcls, self)
			end
		end})
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000088888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000888888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000888888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000888888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000088888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00006666666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00066666666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00666666666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00666666666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00666666666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00006666666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
