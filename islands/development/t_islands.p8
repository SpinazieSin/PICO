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
  x = x,
  y = y,
  angle = 0,

  d_angle = 0.1,
  larm_angle = -0.5,
  rarm_angle = 0.5,
  
  update = function(self)
   local px = self.x
   local py = self.y
   local dx = 0
   local dy = 0
   local d_angle = 0
   
   -- turning
   if btn(0) then
    d_angle = -0.05
   end
   if btn(1) then
    d_angle = 0.05
   end

   -- update angle
   self.angle = self.angle + d_angle

   -- moving
   local angle = self.angle
   if btn(2) then
    dx = -1*sin(angle)
    dy = -1*cos(angle)
   end
   if btn(3) then
    dx = 1*sin(angle)
    dy = 1*cos(angle)
   end

   -- update location
   self.x = px + dx
   self.y = py + dy
  end,

  draw = function(self)
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
 for ix=0,sw-1 do
  for iy=0,sh-1 do
   local dx=ix-x0
   local dy=iy-y0
   local xx=flr(dx*ca-dy*sa+x0)
   local yy=flr(dx*sa+dy*ca+y0)
   if (xx>=0 and xx and yy>=0 and yy<=sh) then
    pset(x+ix,y+iy,sget(sx+xx,sy+yy))
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
