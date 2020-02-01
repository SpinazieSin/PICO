pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
function _init()
 poke(0x5f2d, 1)
 left_press = false
 hold = false
 objects = {}
 add_enemy(40, 40)
 add_enemy(60, 60)
 add_enemy(80, 80)
 cam_x = 0
 cam_y = 0
 mxo = 0
 myo = 0
end

function _update()
 -- cls for collision layer
 cls()
 mx = stat(32)
 my = stat(33)
 mp = stat(34)

 move_camera()

 if mp == 2 then
  right_press = true
 end

 for obj in all(objects) do
  obj:colbox()
 end

 for obj in all(objects) do
  obj:update()
 end

end
 
function _draw()
 -- cls for drawing
 cls(1)
 map()
 for obj in all(objects) do
  obj:draw()
 end

 if mp == 1 then
  left_press = true
 else
  left_press = false
 end

 right_press = false

 if left_press then
  if not(hold) then
   holdx = mx
   holdy = my
   hold = true
  else
   rect(holdx, holdy, mx, my, 11)
  end
 else
  hold = false
 end
 spr(0, mx-3, my)
 print("mem:"..stat(0), cam_x, cam_y, 7)
 print("cpu:"..stat(1), cam_x, cam_y+8, 7)
 print("cpu2:"..stat(2), cam_x, cam_y+16, 7)
end

function move_camera()
 if mp == 4 then
  if not(mid_hold) then
   mid_hold = true
   hmx = mx
   hmy = my
  end
  cam_x += (hmx - mx)
  cam_y += (hmy - my)
  hmx = mx
  hmy = my
 else
  mid_hold = false
  if mx > 116 then
   cam_x += 1
  end
  if my > 116 then
   cam_y += 1
  end
  if mx < 18 then
   cam_x -= 1
  end
  if my < 18 then
   cam_y -= 1
  end
 end
 camera(cam_x, cam_y)
 mx = mx + cam_x
 my = my + cam_y
end

-->8

function add_enemy(x, y)
 add(objects,{
  x=x,
  y=y,
  dx = 0.5,
  dy = 0.5,
  path_index,
  size=6,
  selected = false,
  path = {},
  cooldown = 0,
  update = function(self)
   local x = flr(self.x)
   local y = flr(self.y)
   local cdn = self.cooldown
   if left_press then
    if mid(holdx, x+4, mx) == x+4 and mid(holdy, y+4, my) == y+4 then
     self.selected = true
    else
     self.selected = false
    end
    if mid(x, mx, x+8) == mx  and mid(y, my, y+8) == my then
     self.selected = true 
    end
   end
   if right_press and cdn < 1 then
    if self.selected then
     local gx = snap_mouse(x, mx)
     local gy = snap_mouse(y, my)
     local path = astar({x, y}, {gx, gy}, self.size)
     if path == nil then
      self.path = {}
     else
      self.path = path
      self.path_index = 1
     end
    end
    self.cooldown = 20
   end

   if cdn > 0 then
    self.cooldown -= 1
   end

   local x = self.x
   local y = self.y
   local path = self.path
   if #path > 0 then
    t = path[1]
    if abs(t[1] - x) < 1 and abs(t[2] - y) < 1 then
     del(path, path[1])
    end
    local dx = sgn(t[1] - x)*self.dx
    local dy = sgn(t[2] - y)*self.dy
    if not(pget(x + 4 + 10*dx, y) == 1) then
     self.x += dx
    end
    if not(pget(x, y + 4 + 10*dy) == 1) then
     self.y += dy
    end
   end

  end,
  colbox = function(self)
   local x = self.x
   local y = self.y
   local size = self.size
   rectfill(x, y, size+x, size+y, 1)

  end,
  draw = function(self)
   spr(6, self.x, self.y)
   if self.selected then
    spr(16, self.x, self.y)
   end
  end})
end
-->8

-- a* --
-- returns a path from start to goal
-- where start and goal are arbitrary map locations
-- if no path exists return nil
function astar(start, goal, size)
 found_goal = false
 frontier = {}
 insert(frontier, start, 0)
 came_from = {}
 came_from[vectoindex(start)] = nil
 cost_so_far = {}
 cost_so_far[vectoindex(start)] = 0

 -- a* --
 -- #frontier < n indicates max search space
 while (#frontier > 0 and #frontier < 200) do
  current = popend(frontier)

  if vectoindex(current) == vectoindex(goal) then
   found_goal = true
   break
  end

  local neighbours = getneighbours(current, size)

  for next in all(neighbours) do
   local nextindex = vectoindex(next)
   local new_cost = cost_so_far[vectoindex(current)] + 1 -- add extra costs here

   if (cost_so_far[nextindex] == nil) or (new_cost < cost_so_far[nextindex]) then
    cost_so_far[nextindex] = new_cost
    local priority = new_cost + heuristic(start, goal, next)
    insert(frontier, next, priority)
    came_from[nextindex] = current
   end 
  end
 end

 -- the important bit
 if found_goal then
  current = came_from[vectoindex(goal)]
  path = {}
  local cindex = vectoindex(current)
  local sindex = vectoindex(start)

  while cindex != sindex do
   add(path, current)
   current = came_from[cindex]
   cindex = vectoindex(current)
  end
  reverse(path)
  
  return path
 else
  return nil
 end
end

function heuristic(start, a, b)
 local b1 = b[1]
 local b2 = b[2]
 local a1 = a[1]
 local a2 = a[2]
 local dx1 = a1 - b1
 local dy1 = a2 - b2
 local dx2 = start[1] - b1
 local dy2 = start[2] - b2
 return abs(dx1*dy2 - dx2 * dy1)*0.001 + (abs(a1 - b1) + abs(a2 - b2))
end

-- a* --
-- in case you want to modify the neighbour function
function getneighbours(pos, size)
 local neighbours={}
 local x = pos[1]
 local y = pos[2]

 if not(fget(mget((x-2)/8,y/8), wallid)) then
  -- mset((x-2)/8,y/8, 48)
  add(neighbours,{x-2,y})
 end
 if not(fget(mget((x+size)/8,y/8), wallid)) then
  -- mset((x+size)/8,y/8, 48)
  add(neighbours,{x+2,y})
 end
 if not(fget(mget(x/8,(y-2)/8), wallid)) then
  -- mset(x/8,(y-2)/8, 48)
  add(neighbours,{x,y-2})
 end
 if not(fget(mget(x/8,(y+size)/8), wallid)) then
  -- mset(x/8,(y+size)/8, 48)
  add(neighbours,{x,y+2})
 end
 -- for making diagonals
 if (x+y) % 2 == 0 then
  reverse(neighbours)
 end
 return neighbours
end

function insert(t, val)
 for i=(#t+1),2,-1 do
  t[i] = t[i-1]
 end
 t[1] = val
end

function insert(t, val, p)
 if #t >= 1 then
  add(t, {})
  for i=(#t),2,-1 do
   local next = t[i-1]
   if p < next[2] then
    t[i] = {val, p}
    return
   else
    t[i] = next
   end
  end
  t[1] = {val, p}
 else
  add(t, {val, p}) 
 end
end

function popend(t)
 local top = t[#t]
 del(t,t[#t])
 return top[1]
end

function reverse(t)
 for i=1,(#t/2) do
  local temp = t[i]
  local oppindex = #t-(i-1)
  t[i] = t[oppindex]
  t[oppindex] = temp
 end
end

function vectoindex(vec)
 return ((vec[1]+1) * 512) + vec[2]
end

function snap_mouse(c, mc)
 if (c-mc)%2 == 0 then
  return mc
 else
  return mc+1
 end
end
__gfx__
00010000000010000000000000710cc1000001b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001c10000011b1100000b000000b10c1001111b10100001010000001000000000000000000000000000000000000000000000000000000000000000000000000
01b7c10000100010000101001111b0c101bbbbb10c0000c00c7dd7c0000000000000000000000000000000000000000000000000000000000000000000000000
1bbbcc1001b070b1001070101bbbbcc101bccc11007dd70000e11e00000000000000000000000000000000000000000000000000000000000000000000000000
bb7c7cc0001000100b07070b1bbcccc101b77c1000e11e0000cccc00000000000000000000000000000000000000000000000000000000000000000000000000
bbb1ccc00011b110011111111b0c111111bbbc100cccccc000c00c00000000000000000000000000000000000000000000000000000000000000000000000000
1b101c1000001000000010001b01c0001ccccc10cc0000cc0cc00cc0000000000000000000000000000000000000000000000000000000000000000000000000
0100010000000000000000001bb017000c1111001100001101100110000000000000000000000000000000000000000000000000000000000000000000000000
bb0000bb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b000000b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b000000b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bb0000bb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
