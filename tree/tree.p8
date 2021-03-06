pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- default function

function _init()
 zoom_factor = 2
 branch_factor = 3
 maxangle = 200
 maxangle2 = maxangle/2
 minspeed = 5
 maxlen = 20

 -- branch probability is 1/p_branch per frame
 p_branch = 100

 -- zoom level
 zoom_level = 1

 -- gametime
 gt = 0

 -- camera
 cx, cy = 0, 0

 -- player
 px, py = 63, 100

 -- branch list
 branches = {} 

 -- initial tree
 bx, by = 63, 127
 make_branch(bx, by, 20, 0.01, 0.5)
end

function _update()
 -- update gametime
 gt = gt + 1

 -- update camera
 update_camera()
 
 -- update branches
 for branch in all(branches) do
  branch:update()
  
  -- only unsprouted, complete branches may sprout
  if branch.sprouted == 0 and branch.complete then

   local pb = p_branch
   -- player branch prob
   if abs(px - branch.xc) + abs(py - branch.yc) < 10 then
    -- pb = pb/10
   end

   -- check branch prob
   if rnd(pb) < 2 then
    local n_branches = flr(rnd(branch_factor)+1)
    branch.sprouted = n_branches
    for i=0,n_branches do
     make_branch(branch.xn, branch.yn, rnd(maxlen)+10, branch.angle+(rnd(maxangle)-maxangle2)/1000, rnd(minspeed)/minspeed)
    end
   end
  end
 end
end

function _draw()
 cls()

 -- draw branches
 for branch in all(branches) do
  branch:draw()
 end

 -- spr(0, px, py)
end

-->8
-- branch code
function make_branch(x0, y0, len, angle, speed)
 local xn = x0-len*sin(angle)
 local yn = y0-len*cos(angle)
 add(branches, {
  col = 7, -- color
  speed = speed, -- growth speed
  angle = angle,
  x0 = x0, -- x init
  y0 = y0, -- y init
  xc = x0, -- x current
  yc = y0, -- y current
  xn = xn, -- x final
  yn = yn, -- y final
  dx = (xn - x0)/len, -- x interpolation
  dy = (yn - y0)/len, -- y interpolation
  complete = false, -- done drawing
  stop = false, -- stops growing
  sprouted = 0, -- amount of sprouted branches
  
  -- update
  update = function(self)
   -- is branch fully grown?
   if not complete then
    if abs(self.xc - self.xn) < abs(self.dx*2) and
       abs(self.yc - self.yn) < abs(self.dy*2) then
     self.xc = self.xn
     self.yc = self.yn
     self.complete = true
     self.stop = true
    end
   end

   -- growing
   if not self.stop then
    self.xc = self.xc + self.dx*self.speed
    self.yc = self.yc + self.dy*self.speed
   end
  end,

  -- draw
  draw = function(self)
   line(self.x0/zoom_level, self.y0/zoom_level, self.xc/zoom_level, self.yc/zoom_level, self.col)
  end
  })
end

-->8
function update_camera()
 local cdx = 0
 local cdy = 0
 if btn(0) then
  cdx = -1
 end
 if btn(1) then
  cdx = 1
 end
 if btn(2) then
  cdy = -1
 end
 if btn(3) then
  cdy = 1
 end

 if btn(4) then
  zoom_level = 2
 end

 if btn(5) then
  zoom_level = 1
 end

 cx = cx + cdx
 cy = cy + cdy
 px = px + cdx
 py = py + cdy
 camera(cx, cy)
end


__gfx__
44444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fcffcf40000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffff40000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09999440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09999040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e00e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
