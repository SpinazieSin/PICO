pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- default functions

function _init()
 -- gametime
 gt = 0

 -- all ingame objects
 objects = {}

 -- spawn player
 add_boy(63, 63)
 g_larmx = 63+0
 g_larmy = 63+3
 g_rarmx = 63+6
 g_rarmy = 63+3
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
  larmx = x,
  larmy = y+3,
  larmxn = x,
  larmyn = y+3,
  larm_angle = -0.25,

  -- right arm
  rarmx = x+6,
  rarmy = y+3,
  rarmxn = x+6,
  rarmyn = y+3,
  rarm_angle = 0.25,

  
  update = function(self)
   local px = self.x
   local py = self.y
   local dx = 0
   local dy = 0
   local d_angle = 0
   local ct = gt/self.cycle_time
   
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
   local arm_scale = momentum + 0.4*sin(ct)
   if momentum > 0.5 then
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
   local larmx = self.larmx + dx-- - sin(angle)*turning
   local larmy = self.larmy + dy-- - sin(angle)*turning
   local rarmx = self.rarmx + dx-- + sin(angle)*turning
   local rarmy = self.rarmy + dy

   self.larmx = larmx
   self.larmy = larmy
   self.rarmx = rarmx
   self.rarmy = rarmy



   local larm_angle = angle + 0.25 + 0.15 * sin(ct/2)
   local rarm_angle = angle - 0.25 + 0.15 * sin(ct/2)
   self.larmxn = larmx + arm_scale * 4 *sin(larm_angle)
   self.larmyn = larmy + arm_scale * 4 *cos(larm_angle)
   self.rarmxn = rarmx + arm_scale * 4 *sin(rarm_angle)
   self.rarmyn = rarmy + arm_scale * 4 *cos(rarm_angle)

   -- local arm_len = self.arm_len * momentum
   -- local xturn = sin(angle)*(d_angle/0.05)
   -- local yturn = cos(angle)*(d_angle/0.05)
   -- local larmx = self.larmx + dx - xturn
   -- local larmy = self.larmy + dy - yturn
   -- local rarmx = self.rarmx + dx + xturn
   -- local rarmy = self.rarmy + dy + yturn
   -- self.larmx = larmx
   -- self.larmy = larmy
   -- self.rarmx = rarmx
   -- self.rarmy = rarmy
   
   -- self.larmxn = larmx + arm_len * sin(larm_angle) - xturn
   -- self.larmyn = larmy + arm_len * cos(larm_angle) + xturn
   -- self.rarmxn = 1 + rarmx + arm_len * sin(rarm_angle)
   -- self.rarmyn = rarmy + arm_len * cos(rarm_angle)

  end,

  draw = function(self)
   local angle = self.angle
   local sa = sin(angle)
   local ca = cos(angle)
   local laox = 4 * ca
   local laoy = 4 * sa
   local raox = 2 * ca
   local raoy = 3 * sa
   line(self.larmx + 4 - laox, self.larmy + laoy, self.larmxn + 4 - laox, self.larmyn + laoy, 7)
   line(self.rarmx - 2 + raox, self.rarmy - raoy, self.rarmxn - 2 + raox, self.rarmyn - raoy, 7)
   spr_r(0, self.x, self.y, self.angle)
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
    if col ~= 1 then
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
