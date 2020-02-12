pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- ~noel berry~
--  topdown 3d

-- camera variables
cam_x=0
cam_y=0
top  =0
left =0
cam_mod_x=0
cam_mod_y=0

function _update()
 -- move camera
 if btn(0) then cam_x-=2 end
 if btn(1) then cam_x+=2 end
 if btn(2) then cam_y-=2 end
 if btn(3) then cam_y+=2 end

 -- update left/top tile positions
 left=cam_x/8
 top=cam_y/8
 cam_mod_x=cam_x%8
 cam_mod_y=cam_y%8
end

function _draw()

 cls()
 camera(cam_x,cam_y)

 -- draw tiles
 -- (order them from further out inwards)
 -- to add objects, will need to sort these
 -- into a list with objects in it as well,
 -- instead of doing it like this
 for tx=0,8 do
 for ty=0,8 do
 draw_tile(left+tx,top+ty)
 draw_tile(left+16-tx,top+ty)
 draw_tile(left+tx,top+16-ty)
 draw_tile(left+16-tx,top+16-ty)
 end
 end

 -- stats
 camera()
 color(8)
 print(stat(1))

end

function draw_tile(tx,ty)
 local t=mget(tx,ty)
 if (t>0 and t<5) then

 -- get positions
 local x=tx*8-cam_mod_x
 local y=ty*8-cam_mod_y

 -- get position at height t
 local tlx,tly=height(x,y,t)
 local brx,bry=height(x+8,y+8,t)

 -- draw the tile edge
 -- but only if we have to
 if mget(tx-1,ty)<t or 
 mget(tx+1,ty)<t or 
 mget(tx,ty-1)<t or 
 mget(tx,ty+1)<t then
 local len=t*2
 for i=0,len-1 do
 local p=i/len
 rectfill(x+(tlx-x)*p,
 y+(tly-y)*p,
 x+8+(brx-(x+8))*p,
 y+8+(bry-(y+8))*p,1)
 end
 end

 -- draw surface
 rectfill(tlx,tly,brx,bry,1+t)
 --sspr(t*8,0,8,8,tlx,tly,brx-tlx+1,bry-tly+1)

 end
end

-- gets the "height" from the center
function height(x,y,t)
 return x+(x-cam_x-64)*0.2*t,
 y+(y-cam_y-64)*0.2*t
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
