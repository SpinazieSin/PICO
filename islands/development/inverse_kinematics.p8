pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- default functions

function _init()
 ox, oy = 50, 63
 tx, ty = 63, 63
 po = {}
 po.x, po.y = ox, oy
 pt = {}
 pt.x, pt.y = tx, ty

 alen = 8
 clen = 8

end

function _update()
 cls()

 if btn(0) then
  pt.x -= 1
  tx -= 1
 end
 if btn(1) then
  pt.x += 1
  tx += 1
 end
 if btn(2) then
  pt.y -= 1
  ty -= 1
 end
 if btn(3) then
  pt.y += 1
  ty += 1
 end  

 blen = distance(po, pt)

 local ja = 0
 local jb = 0
 local cx = 0
 local cy = 0
 local bx = 0
 local by = 0
 local offset = 1
 
 if blen > 16 then
  ja = handangle(ox, oy, tx, ty)
  jb = ja
  offset = -1
 else
  ja = jointa(alen, blen, clen, ox, oy, tx, ty)
  jb = ja-jointb(alen, blen, clen)---0.5
 end

 cx = ox-alen*sin(ja)
 cy = oy-alen*cos(ja)
 bx = cx+clen*sin(jb)*offset
 by = cy+clen*cos(jb)*offset

 line(cx, cy, bx, by, 7)
 line(ox, oy, cx, cy, 10)
 circfill(ox,oy,1,1, 11)
 circfill(tx,ty,1,8, 12)
end

function _draw()
 print()
end

-->8
function acos(x)
 return atan2(x,-sqrt(1-x*x))
end

function asin(x)
 return atan2(sqrt(1-x*x),-x)
end

function distance(p0, p1)
 local dx = p0.x - p1.x
 local dy = p0.y - p1.y
 
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
44444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fcffcf40000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffff40000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09999440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09999040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e00e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
