pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- default functions
function _init()
 -- gametime
 gt = 0
 anim_time = 30/4

 -- leg targets
 local ox, oy = 60, 57
 targetx, targety = 60, 60

 local alen = 7
 local clen = 8

 height = 57

 left  = make_leg(ox, oy, alen, clen)
 right = make_leg(ox, oy, alen, clen)
 left.tx = targetx
 left.ty = targety
 left.tx = targetx-10
 left.ty = targety

 prev_lx, prev_ly = left.ox, left.oy
 prev_rx, prev_ry = right.ox, right.oy

 speed = 1
 momentum = 1
 max_momentum = 100
 prev_dx = 1
end

function _update()
 cls()
 camera(left.ox-50, 0)
 -- update gametime
 gt += 1

 -- move body sideways
 local dx = 0
 local dy = 0
 if btn(0) then
  dx -= 1
 end
 if btn(1) then
  dx += 1
 end
 if btn(2) then
  dy -= 1
 end
 if btn(3) then
  dy += 1
 end

 -- momentum
 if dx > 0 then
  if momentum < max_momentum then
   momentum += 5
  end
 elseif momentum > 11 then
  momentum -= 7
 end

 -- move body up an down
 if btn(2) then
  height-= 0.1
  height-= 0.1
 end
 if btn(3) then
  height+= 0.1
  height+= 0.1
 end

 if abs(dx) > 0 or momentum > 11 then
  local cycle_time = 60

  local momentum_scale = momentum/max_momentum
  anim_time += (1+momentum_scale)*sgn(dx)
  prev_dx = dx

  left.oy = height + abs(cos((anim_time)/cycle_time))*1.5
  right.oy = height + abs(cos((anim_time)/cycle_time))*1.5

  -- calc left movement
  local lx_offset = (3*momentum_scale + 4)*sin(anim_time/cycle_time) + 1.5 - momentum_scale
  local lx = left.ox + lx_offset
  local dlx = prev_lx - lx
  prev_lx = lx
  local ly = left.oy + 14.5 + 3*cos(anim_time/cycle_time) - 2*momentum_scale
  prev_ly = ly

  -- calc right movement
  local rx_offset = (3*momentum_scale + 4)*sin((anim_time+(cycle_time/2))/cycle_time) + 1.5 - momentum_scale
  local rx = right.ox + rx_offset
  local drx = prev_rx - rx
  prev_rx = rx
  local ry = right.oy + 14.5 + 3*cos((anim_time+(cycle_time/2))/cycle_time) - 2*momentum_scale
  prev_ry = ry

  -- move feet
  left:move_to(lx, ly, 1)
  right:move_to(rx, ry, 1)

  -- move body
  left.ox += flr(sgn(dx)*1) + 1*momentum_scale
  right.ox+= flr(sgn(dx)*1) + 1*momentum_scale
  -- anim_time = 30/4
 elseif (not left.grounded or not right.grounded) and (anim_time-15)%30 > 2 then
  local cycle_time = 60
  local momentum_scale = 0
  anim_time += (1+momentum_scale)*sgn(prev_dx)

  left.oy = height-- + abs(cos((anim_time)/cycle_time))*1.5
  right.oy = height-- + abs(cos((anim_time)/cycle_time))*1.5

  -- calc left movement
  local lx_offset = (3*momentum_scale + 4)*sin(anim_time/cycle_time) +1
  local lx = left.ox + lx_offset
  local dlx = prev_lx - lx
  prev_lx = lx
  local ly = left.oy + 14.5 + 3*cos(anim_time/cycle_time) - 2*momentum_scale
  prev_ly = ly

  -- calc right movement
  local rx_offset = (3*momentum_scale + 4)*sin((anim_time+(cycle_time/2))/cycle_time) +1
  local rx = right.ox + rx_offset
  local drx = prev_rx - rx
  prev_rx = rx
  local ry = right.oy + 14.5 + 3*cos((anim_time+(cycle_time/2))/cycle_time) - 2*momentum_scale
  prev_ry = ry

  -- move feet
  left:move_to(lx, ly, 1)
  right:move_to(rx, ry, 1)

  -- move body
  left.ox += flr(sgn(dx)*1) + 1*momentum_scale
  right.ox+= flr(sgn(dx)*1) + 1*momentum_scale
 else
  local cycle_time = 120
  left.oy = height + 0.5 + abs(cos((gt)/cycle_time))*1.5
  right.oy = height + 0.5 + abs(cos((gt)/cycle_time))*1.5
 end

 left:update()
 right:update()
end

function _draw()
 map()
 left:draw()
 right:draw()
end

-->8
function make_leg(ox, oy, alen, clen)
 
 local leg = {}

 -- origin
 leg.ox = ox
 leg.oy = oy

 -- default target
 leg.tx = ox-alen
 leg.ty = oy-alen

 -- default position
 leg.cx = ox
 leg.cy = oy-clen
 leg.bx = ox
 leg.by = leg.cy + alen

 -- general properties
 leg.front = true
 leg.grounded = false

 -- update inverse kinematics
 leg.update = function(self, interpolation)
  -- will the interpolation?
  interpolation = 0

  -- origin and target
  local ox, oy, tx, ty = self.ox, self.oy, self.tx, self.ty
  blen = distance(ox, oy, tx, ty)

  local ja = 0
  local jb = 0
  local cx = 0
  local cy = 0
  local bx = 0
  local by = 0
  local offset = 1
  
  -- target outside of range
  if blen > alen+clen then
   ja = handangle(ox, oy, tx, ty)
   jb = ja
   offset = -1
  -- target inside inner bound
  else
   ja = jointa(alen, blen, clen, ox, oy, tx, ty)
   jb = ja-jointb(alen, blen, clen)
  end

  self.cx = ox-clen*sin(ja)
  self.cy = oy-clen*cos(ja)
  self.bx = self.cx+alen*sin(jb)*offset
  self.by = self.cy+alen*cos(jb)*offset
 end

 -- linear movement
 leg.move_to = function(self, tx, ty, speed)
  if speed == nil then
   self.tx = tx
   self.ty = ty
  else
   local newtx = (1 - speed) * self.tx + speed * tx
   local newty = (1 - speed) * self.ty + speed * ty
   if not fget(mget(newtx/8, self.ty/8), 0) then
    self.tx = newtx
   end
   if not fget(mget(self.tx/8, newty/8), 0) then
    self.ty = newty
   end
  end
 end

 -- draw
 leg.draw = function(self)
  local cx, cy = self.cx, self.cy
  line(cx, cy, self.bx, self.by, 7)
  line(self.ox, self.oy, cx, cy, 10)
 end

 return leg
end

-->8
-- math
function acos(x)
 return atan2(x,-sqrt(1-x*x))
end

function asin(x)
 return atan2(sqrt(1-x*x),-x)
end

function distance(x0, y0, x1, y1)
 local dx = x0 - x1
 local dy = y0 - y1
 
 return sqrt(dx*dx+dy*dy)
end

function alpha(a, b, c)
 return asin((b*b + c*c - a*a)/(2*b*c))
end

function jointb(a, b, c)
 return acos((a*a + c*c - b*b)/(2*a*c))
end

function handangle(cx, cy, ax, ay)
 return atan2(cy - ay, cx - ax)
end

function jointa(a, b, c, cx, cy, ax, ay)
 local a = alpha(a, b, c)
 local da = handangle(cx, cy, ax, ay)-0.25
 return a + da
end



__gfx__
44444440eeeeeeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fcffcf40eeeeeeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffff40eeeeeeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09999440eeeeeeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09999040eeeeeeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e00e000eeeeeeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000eeeeeeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000eeeeeeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
