pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- default functions

function _init()
 gt = 0

 joints = {}
 verts = {}

 add_arm(66, 63, false)
 add_arm(60, 63, true)
end

function _update()
 gt += 1
 cls()
 foreach(joints, update_joint)
 foreach(verts, update_vert)
end

function _draw()
 foreach(joints, draw_joint)
 foreach(verts, draw_vert)
end

-->8
-- arms
function add_arm(x, y, left)
 local friction = 0.9
 local shoulder = true
 local elbow = true
 local hand = true
 local left = left
 local ljx = x
 local ljy = y
 local lj1 = make_joint(ljx, ljy, shoulder, false, false, friction)
 local lj2 = make_joint(ljx, ljy+2, false, elbow, false, friction)
 local lj3 = make_joint(ljx, ljy+3, false, false, hand, friction)

 make_vert(lj2, lj3)
 make_vert(lj1, lj2)
end

function make_joint(x, y, shoulder, elbow, hand, friction)
 local p = {}
 p.x = x
 p.y = y
 p.oldx = rnd(5) + x-1
 p.oldy = rnd(5) + y-1
 p.vx = vx
 p.vy = vy
 p.color = flr(6+rnd(6))
 p.friction = friction
 p.shoulder = shoulder
 
 add(joints, p)
 return p
end

function make_vert(p0,p1)
 local s = {}
 
 s.p0 = p0
 s.p1 = p1
 s.length = distance(p0,p1)
 
 add(verts, s)
 
 return s
end

function update_joint(p)
 if p.shoulder then
  if btn(0) then
   p.x -= 1
  elseif btn(1) then
   p.x += 1
  end
  if btn(2) then
   p.y -=1
  elseif btn(3) then
   p.y +=1
  end
 else
  p.vx = (p.x - p.oldx) * p.friction
  p.vy = (p.y - p.oldy) * p.friction

  p.oldx = p.x
  p.oldy = p.y
  
  p.x += p.vx-- + 0.1*sin(gt/28)
  p.y += p.vy-- + 0.1*cos(gt/28)
 end  
end

function update_vert(s)
  local dx = s.p1.x - s.p0.x
  local dy = s.p1.y - s.p0.y
  
  local dist    = sqrt(dx*dx+dy*dy)
  local diff    = s.length - dist
  local percent = diff/dist/2
  local offsetx = dx*percent
  local offsety = dy*percent
  
  if not s.p0.shoulder then
   s.p0.x -= offsetx
   s.p0.y -= offsety
  end

  if not s.p1.shoulder then
   s.p1.x += offsetx
   s.p1.y += offsety
  end
end

function draw_joint(p)
  color(p.color)
  rectfill(p.x,p.y,p.x,p.y)  
end

function draw_vert(s)
 color(7)
 line(s.p0.x, s.p0.y, s.p1.x, s.p1.y)
end

function distance(p0, p1)
 local dx = p0.x - p1.x
 local dy = p0.y - p1.y
 
 return sqrt(dx*dx+dy*dy)
end

__gfx__
44444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fcffcf40000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffff40000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09999440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09999040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e00e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
