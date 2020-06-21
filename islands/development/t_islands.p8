pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- default functions

function _init()
 -- gametime
 gt = 0

 -- all ingame objects
 objects = {}
 arms = {}

 -- spawn player
 add_arm(69, 66, true)
 add_arm(63, 66, false)
 add_boy(63, 63)
 girlx = 30
 girly = 63
 add_girl(girlx, girly)
end

function _update()
 -- update gametime
 gt = gt + 1
 
 -- update objects
 for obj in all(objects) do
  obj:update()
 end
end

function _draw()
 cls()

 -- draw objects
 for obj in all(objects) do
  obj:draw()
 end
end

-->8
-- arms
function add_arm(x, y, left)
 return {
  l1_angle = 0,
  l1_x = x,
  l1_y = y,

  l2_x = 0,
  l2_y = 0,
  l2_len = 3,
  l2_angle = 0,
  
  l3_x = 0,
  l3_y = 0,
  l3_len = 4,
  l3_angle = 0.25,

  left = left,
  scale = 1,
  momentum = 0,
  pointing = false,
  girl_angle = 0,
  cycle_time = 28,

  update = function(self)
   local momentum = self.momentum

   -- regular walking
   if momentum > 0.1 and not self.pointing then
    local scale = self.scale
    local ct = gt/self.cycle_time
    local sc = scale*sin(ct)-- + self.l1_angle
    local sc2 = sc

    if self.left then
     self.l2_angle = 0.28 - 0.10*sc2
     self.l3_angle = -0.2 - 0.10*sc2
    else
     self.l2_angle = -0.28 - 0.10*sc2
     self.l3_angle = 0.2 - 0.10*sc2
    end
   elseif self.pointing then
    self.l2_angle = self.girl_angle
    self.l3_angle = 0
   end
  end,

  draw = function(self)
   local momentum = self.momentum

   local angle = self.l1_angle
   local sa = sin(angle)
   local ca = cos(angle)
   local aox = 4 - 4 * ca
   local aoy = 4 * sa
   if self.left then
    aox = - 2 + 2 * ca
    aoy = - 3 * sa
   end

   local l1_x = self.l1_x + aox
   local l1_y = self.l1_y + aoy
   local l2_len = self.l2_len * momentum
   local l2_angle = self.l2_angle + angle
   local l3_len = self.l3_len * momentum
   local l3_angle = self.l3_angle + l2_angle

   -- link 2 coords
   local l2_x = l1_x - l2_len * sin(l2_angle)
   local l2_y = l1_y - l2_len * cos(l2_angle)

   -- link 3 coords
   local l3_x = l2_x - l3_len * sin(l3_angle)
   local l3_y = l2_y - l3_len * cos(l3_angle)

   -- update variables
   self.l2_x = l2_x
   self.l2_y = l2_y
   self.l3_x = l3_x
   self.l3_y = l3_y

   line(l1_x, l1_y, l2_x, l2_y, 7)
   line(l2_x, l2_y, l3_x, l3_y, 7)
   -- line(self.larmx + 4 - laox, self.larmy + laoy, self.larmxn + 4 - laox, self.larmyn + laoy, 7)
   -- line(self.rarmx - 2 + raox, self.rarmy - raoy, self.rarmxn - 2 + raox, self.rarmyn - raoy, 7)

  end
  }
end


-->8
-- player character
function add_boy(x, y)
 add(objects, {
  -- position
  cycle_time = 14,
  x = x,
  y = y,
  angle = 0,
  d_angle = 0.1,
  momentum = 0,
  dmomentum = 0.1,
  pendulum = 0,

  -- arms
  arm_len = 3,

  -- left arm
  larm = add_arm(x, y+3, false),

  -- right arm
  rarm = add_arm(x+6, y+3, true),
  
  update = function(self)
   local px = self.x
   local py = self.y
   local dx = 0
   local dy = 0
   local d_angle = 0
   local ct = gt/self.cycle_time
   local pointing = false

   if btn(4) then
    pointing = true

   end
   
   -- turning
   if btn(0) then
    d_angle = -0.05
   end
   if btn(1) then
    d_angle = 0.05
   end

   -- update angle
   self.angle = self.angle + d_angle
   if self.angle > 1 then
    self.angle = self.angle - 1
   elseif self.angle < -1 then
    self.angle = self.angle + 1
   end

   -- moving
   local angle = self.angle
   local moving = false
   local momentum = self.momentum + 0.1

   local momentum_scale = momentum
   local arm_scale = 1
   if momentum > 0.5 then
    arm_scale = momentum + 0.4*sin(ct)
    momentum_scale = momentum + 0.4*sin(ct)
   end

   if btn(2) then
    dx = - 1 * sin(angle) * momentum_scale
    dy = - 1 * cos(angle) * momentum_scale
    moving = true
   end

   -- if btn(3) then
   --  dx = 1 * sin(angle) * momentum
   --  dy = 1 * cos(angle) * momentum
   --  moving = true
   -- end

   if moving and momentum < 0.9 then
    self.momentum = momentum
   elseif not moving and momentum > 0 then
    self.momentum = momentum - 0.4
   end

   -- update location
   self.x = px + dx
   self.y = py + dy

   -- update arms
   local larmx = self.larm.l1_x + dx-- - sin(angle)*turning
   local larmy = self.larm.l1_y + dy-- - sin(angle)*turning
   local rarmx = self.rarm.l1_x + dx-- + sin(angle)*turning
   local rarmy = self.rarm.l1_y + dy

   self.larm.l1_x = larmx
   self.larm.l1_y = larmy
   self.rarm.l1_x = rarmx
   self.rarm.l1_y = rarmy

   self.larm.l1_angle = angle
   self.rarm.l1_angle = angle

   self.larm.scale = arm_scale
   self.rarm.scale = arm_scale

   self.larm.momentum = momentum
   self.rarm.momentum = momentum

   self.larm:update()
   self.rarm:update()
  end,

  draw = function(self)
   local angle = self.angle
   local x = self.x
   local y = self.y
   print(angle)
   print(atan2(x - girlx, y - girly))---angle)
   self.larm:draw()
   self.rarm:draw()
   spr_r(0, self.x, self.y, self.angle)
  end
  })
end
-->8
-- girl code
function add_girl(x, y)
 add(objects, {
  x = x,
  y = y,

  update = function(self)
   girlx = self.x
   girly = self.y
  end,

  draw = function(self)
   circfill(self.x,self.y,1,9)
  end
  })
end

-->8
-- rotate sprite code
function spr_r(s,x,y,a)
 local sw=8--set sprite height here
 local sh=8--set sprite height here
 local sx=0--sprite x on sheet
 local sy=0--sprite y on sheet
 local x0=flr(0.5*sw)
 local y0=flr(0.5*sh)
 local sa=sin(a)
 local ca=cos(a)
 local col = 0
 for ix=0,sw-1 do
  for iy=0,sh-1 do
   local dx=ix-x0
   local dy=iy-y0
   local xx=flr(dx*ca-dy*sa+x0)
   local yy=flr(dx*sa+dy*ca+y0)
   if (xx>=0 and xx and yy>=0 and yy<=sh) then
    col = sget(sx+xx,sy+yy)
    if col > 0 then
     pset(x+ix,y+iy,col)
    end
   end
  end
 end
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88666880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
86666680000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88666880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
