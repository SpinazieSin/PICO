pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function _init()
 cam_x = 0
 cam_y = 0
 wallid = 1
 goal_x = 1
 goal_y = 1
 rough_terrain_id = 3
end

function astar(start, goal)
 found_goal=false
 frontier = {}
 insert(frontier, start, 0)
 came_from = {}
 came_from[vectoindex(start)] = nil
 cost_so_far = {}
 cost_so_far[vectoindex(start)] = 0

 while (#frontier > 0 and #frontier < 1000) do
  current = popend(frontier)

  if vectoindex(current) == vectoindex(goal) then
   found_goal=true
   break
  end

  local neighbours = getneighbours(current)

  for next in all(neighbours) do
   -- if next is rough terrain, add custom cost
   if fget(mget(next[1], next[2]), rough_terrain_id) then
    terrain_cost = 2
   else
    terrain_cost = 1
   end 
   local nextindex = vectoindex(next)
   local new_cost = cost_so_far[vectoindex(current)] + 1 -- add extra costs here

   if (cost_so_far[nextindex] == nil) or (new_cost < cost_so_far[nextindex]) then
    cost_so_far[nextindex] = new_cost
    local priority = new_cost + heuristic(goal, next)
    insert(frontier, next, priority)
    
    came_from[nextindex] = current
    
    if (nextindex != vectoindex(start)) and (nextindex != vectoindex(goal)) then
     mset(next[1],next[2],19)
    end
   end 
  end
 end

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

  for point in all(path) do
   mset(point[1],point[2],18)
  end
 else
  return nil
 end
end

function _update()
 if (btn(0) and cam_x > 0) then
  cam_x -= 8
  goal_x -= 8
 end
 if (btn(1) and cam_x < 895) then
  cam_x += 8
  goal_x += 8
 end
 if (btn(2) and cam_y > 0) then
  cam_y -= 8
  goal_y -= 8
 end
 if (btn(3) and cam_y < 127) then
  cam_y += 8
  goal_y += 8
 end

 if btn(4) then
  mset(goal_x/8, goal_y/8, 1)
 end

 camera(cam_x, cam_y)

 if btn(4) then
  mset(goal_x/8, goal_y/8, 17)
  start = getspecialtile(16)
  goal = getspecialtile(17)
  astar(start, goal)
 end
end


function _draw()
 cls()
 mapdraw()
end

function heuristic(a, b)
 return abs(a[1] - b[1]) + abs(a[2] - b[2])
end

function getneighbours(pos)
 local neighbours={}
 local x = pos[1]
 local y = pos[2]
 if x > 0 and (mget(x-1,y) != wallid) then
  add(neighbours,{x-1,y})
 end
 if x < 15 and (mget(x+1,y) != wallid) then
  add(neighbours,{x+1,y})
 end
 if y > 0 and (mget(x,y-1) != wallid) then
  add(neighbours,{x,y-1})
 end
 if y < 15 and (mget(x,y+1) != wallid) then
  add(neighbours,{x,y+1})
 end

 -- for making diagonals
 if (x+y) % 2 == 0 then
  reverse(neighbours)
 end
 return neighbours
end

function getspecialtile(tileid)
 for x=cam_x/8,(cam_x/8)+16 do
  for y=cam_y/8,(cam_y/8)+16 do
   local tile = mget(x,y)
   if tile == tileid then
    return {x,y}
   end
  end
 end
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
 return ((vec[1]+1) * 128) + vec[2]
end

__gfx__
000000000ccccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000c111111c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000c111111c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000c111111c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000c111111c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000c111111c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000c111111c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000cccccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00888800077777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08999980070000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08988980070000700002800000015000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08988980070000700008800000055000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08999980070000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00888800077777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0002020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000010101010101010101010101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000010100000000010100000100000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000010100000000000101000100000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000010100000101000000000100000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000010100000101000000000100000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101000001010100010100000000000100000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101000001010000010000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000001010100000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000010000000001000001000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000010001000001000100000000000000000010000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101000000000001010001100001010100000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010000000001000000000001010100000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101000000000000010100000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000632001320043200130001300013000330001300013001230012300123001230012300123001230012300123001230012300123001230012300173001230012300123001730017300173001730017300
