pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
function _init()
	--adjust colors to new pallete
	--	poke(0x5f2e, 1)
	for i in all({1,3,5,6,11,12,15}) do
		pal(i, 128+i, 1)
	end
	
 poke(0x5f2d, 1)
 left_press = false
 hold = false
 units = {}
 enemies = {}
 add_unit(20, 50, 1, true)
 add_unit(20, 70, 1, true)
 add_unit(40, 60, 2, true)
 add_unit(60, 60, 3, true)
 add_unit(80, 60, 4, true)
 add_unit(100, 60, 5, true)
 add_unit(20, 90, 6, true)
 add_unit(20, 110, 6, true)
 add_unit(40, 100, 7, true)
 add_unit(60, 100, 8, true)
 add_unit(80, 100, 9, true)
 add_unit(100, 100, 10, true)
 cam_x = 0
 cam_y = 0
 mxo = 0
 myo = 0
 friendlyid = 1
 enemyid = 2
 attacks = {}
 pcls = {}

 -- init color vars for different races
 col_a = 12
 col_n = 8
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

 for unit in all(units) do
  unit:colbox()
 end

 friendly_selected = false
 for unit in all(units) do
  unit:update()
  if unit.selected then
   friendly_selected = true
  end
 end

 -- resolve combat
 while #attacks > 0 do
  for unit in all(units) do
   unit:recieve(attacks[1])
  end
  del(attacks, attacks[1])
 end

 for pcl in all(pcls) do
  pcl:update()
 end
end
 
function _draw()
 -- cls for drawing
 cls(0)
 map()

 for unit in all(units) do
  unit:shadow()
  unit:draw()
 end

 for pcl in all(pcls) do
  pcl:draw()
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

function anim_state(a, b, c, d, e, f)
 return { spr_n = a, x_width = b, y_width = c, x_offset = d, y_offset = e }
end

function add_unit(x, y, unit_number, isfriendly)
 -- global traits
 local x = x or 63
 local y = y or 63
 local unit_number = unit_number or 1
 local isfriendly = isfriendly or false

 local anim_states
 local shdw
 local size
 local dx
 local dy
 local hp
 local id
 local attack_speed

 if isfriendly then
  id = 1
 else
  id = 2
 end

 -- unit traits
 if unit_number == 1 then
  anim_states = {anim_state(7, 1, 1, 0, 0),
                 anim_state(8, 1, 1, 0, 0)}
  shdw = {x = 3, y = 5, r = 3}
  anim_speed = 12
  attack_speed = 15
  size = 6
  dx = 0.5
  dy = 0.5
  hp = 100
  pow = 40
 elseif unit_number == 2 then
  anim_states = {anim_state(9, 1, 1, 0, 0),
                 anim_state(10, 1, 1, 0, 0)}
  shdw = {x = 4, y = 7, r = 3}
  anim_speed = 12
  attack_speed = 15
  size = 7
  dx = 0.6
  dy = 0.6
  hp = 200
  pow = 80
 elseif unit_number == 3 then
  anim_states = {anim_state(11, 1, 1, 0, -2),
                 anim_state(27, 1, 1, 0, -2)}
  shdw = {x = 3, y = 5, r = 2}
  anim_speed = 12
  attack_speed = 15
  size = 7
  dx = 0.8
  dy = 0.8
  hp = 180
  pow = 90
 elseif unit_number == 4 then
  anim_states = {anim_state(12, 2, 2, 0, 0),
                 anim_state(14, 2, 2, 0, 0)}
  shdw = {x = 7, y = 7, r = 4}
  anim_speed = 18
  attack_speed = 30
  size = 14
  dx = 0.6
  dy = 0.6
  hp = 450
  pow = 190
 elseif unit_number == 5 then
  anim_states = {anim_state(44, 2, 2, 0, 0),
                 anim_state(62, 2, 1, 0, 0)}
  shdw = {x = 7, y = 7, r = 4}
  anim_speed = 18
  attack_speed = 20
  size = 14
  dx = 1.5
  dy = 1.5
  hp = 300
  pow = 225
 elseif unit_number == 6 then
  anim_states = {anim_state(19, 1, 1, 0, 0),
                 anim_state(20, 1, 1, 0, 0)}
  shdw = {x = 7, y = 7, r = 4}
  anim_speed = 12
  attack_speed = 15
  size = 6
  dx = 0.5
  dy = 0.5
  hp = 100
  pow = 40
 elseif unit_number == 7 then
  anim_states = {anim_state(5, 1, 1, 0, 0),
                 anim_state(6, 1, 1, 0, 0),
                 anim_state(21, 1, 1, 0, 0),
                 anim_state(22, 1, 1, 0, 0)}
  shdw = {x = 7, y = 7, r = 4}
  anim_speed = 12
  attack_speed = 15
  size = 7
  dx = 0.6
  dy = 0.6
  hp = 200
  pow = 80
 elseif unit_number == 8 then
  anim_states = {anim_state(23, 1, 1, 0, 0),
                 anim_state(24, 1, 1, 0, 0)}
  shdw = {x = 7, y = 7, r = 4}
  anim_speed = 12
  attack_speed = 15
  size = 7
  dx = 0.8
  dy = 0.8
  hp = 180
  pow = 90
 elseif unit_number == 9 then
  anim_states = {anim_state(25, 2, 2, 0, 0),
                 anim_state(39, 2, 2, 0, 0)}
  shdw = {x = 7, y = 7, r = 4}
  anim_speed = 18
  attack_speed = 20
  size = 14
  dx = 0.8
  dy = 0.8
  hp = 400
  pow = 225
 elseif unit_number == 10 then
  anim_states = {anim_state(35, 2, 2, 0, 0),
                 anim_state(37, 2, 2, 0, 0)}
  shdw = {x = 7, y = 7, r = 4}
  anim_speed = 18
  attack_speed = 30
  size = 14
  dx = 0.6
  dy = 0.6
  hp = 500
  pow = 150
 end

add(units,{
  x=x,
  y=y,
  dx = dx,
  dy = dy,
  size=size,
  hp = hp,
  pow = pow,
  anim_speed = anim_speed,
  anim_states = anim_states,
  isfriendly = isfriendly,
  id = id,
  shdw = shdw,
  unit_number = unit_number,
  attack_speed = attack_speed,
  anim_time = 0,
  anim_index = 1,
  path_index,
  selected = false,
  right_clicked = false,
  moving = false,
  goal = {},
  path = {},
  cooldown = 0,
  attack_time = 0,
  attack_x = 0,
  attack_y = 0,
  prev_dx = 1,
  left = true,
  update = function(self)
   local x = flr(self.x)
   local y = flr(self.y)
   local size = self.size

   -- friendly unit control
   if self.isfriendly then
    -- astar cooldown
    local cdn = self.cooldown

    -- middle of sprite
    local midx = x+(size/2)
    local midy = y+(size/2)
    
    -- left click selection
    if left_press then
     if mid(holdx, midx, mx) == midx and mid(holdy, midy, my) == midy then
      self.selected = true
     else
      self.selected = false
     end
     if mid(x, mx, x+size) == mx  and mid(y, my, y+size) == my then
      self.selected = true
     end
    end

    -- move/attack command
    if right_press and cdn < 1 then
     -- Check if unit is right clicked
     if mid(x, mx, x+size) == mx  and mid(y, my, y+size) == my then
      self.right_clicked = true
     else
      self.right_clicked = false
     end

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
     self.cooldown = 15
    end

    -- merge with other unit, rules for merging are in the merge() function
    for other in all(units) do
     if other.isfriendly then
      dist = abs(other.x - x) + abs(other.y - y)
      if dist < 12 and other != self and other.right_clicked and self.moving then
       merge(self, other)
      end
     end
    end

    -- update cooldown
    if cdn > 0 then
     self.cooldown -= 1
    end

    -- follow path
    local x = self.x
    local y = self.y
    local path = self.path
    if #path > 0 then
     self.moving = true
     t = path[1]
     if abs(t[1] - x) < self.dx*3 and abs(t[2] - y) < self.dy*3 then
      del(path, path[1])
     end
     local tx = t[1] - x
     local ty = t[2] - y

     local dx = sgn(tx)*self.dx
     local dy = sgn(ty)*self.dy

     local xtarget = midx + (1 + size/2)*sgn(dx)
     local ytarget = midy + (1 + size/2)*sgn(dy)
     local xid = pget(xtarget, y)
     local yid = pget(x, ytarget)
     if xid == 0 then
      if abs(tx) > self.dx then
       self.x += dx
       if sgn(dx) == 1 then
        self.left = false
       else
        self.left = true
       end
      end
     end
     if yid == 0 then
      if abs(ty) > self.dy then
       self.y += dy
      end
     end

     if xid == enemyid and self.attack_time == 0 then
      self.attack_x = 2*sgn(dx)
      self.x += self.attack_x
      self.attack_time += 1
      add(attacks, {x = xtarget, y = y, pow = self.pow, friendly = self.isfriendly})
      add_particle(5, xtarget, y, 3,nil,nil, 1)
      for _=1,4 do
       add_particle(flr(rnd(1.9)+col_n), xtarget, y, flr(rnd(1.9)+1), nil, nil, rnd(.9)+1)
      end
      dx, dy = 0
     elseif yid == enemyid and self.attack_time == 0 then
      self.attack_y = 2*sgn(dy)
      self.y += self.attack_y
      self.attack_time += 1
      add(attacks, {x = x, y = ytarget, pow = self.pow, friendly = self.isfriendly})
      dx, dy = 0
      add_particle(5, x, ytarget, 3,nil,nil, 1)
      for _=1,4 do
       add_particle(flr(rnd(1.9)+col_n), x, ytarget, flr(rnd(1.9)+1), nil, nil, rnd(.9)+1)
      end
     end
    else
     self.moving = false
    end

    if self.attack_time > 0 then
     self.attack_time += 1
     if self.attack_time > self.attack_speed then
      self.attack_time = 0
      self.x -= self.attack_x
      self.y -= self.attack_y
     end
    end

   -- enemy unit control
   else
   end
   if self.hp < 0 then
    del(units, self)
    printh("dead particles")
   end
  end,
  
  colbox = function(self)
   local x = self.x
   local y = self.y
   local size = self.size
   rectfill(x, y, size+x, size+y, self.id)
  end,

  recieve = function(self, atk)
   if atk.friendly == self.isfriendly then
    return
   end
   local x = self.x
   local y = self.y
   local atkx = atk.x
   local atky = atk.y
   if mid(x, atkx, x+self.size) == atkx and mid(y, atky, y+self.size) == atky then
    self.hp -= atk.pow
   end
  end,

  shadow = function(self)
   local shdw = self.shdw
   circfill(self.x + shdw.x, self.y + shdw.y , shdw.r, 0)
  end,

  draw = function(self)
   -- increment animation
   if self.anim_time%self.anim_speed == 0 then
    self.anim_index += 1
    if self.anim_index > 2 then
     self.anim_index = 1
    end
    self.anim_time = 0
   end
   self.anim_time += 1
   
   local anim = self.anim_states[self.anim_index]
   spr(anim.spr_n, self.x + anim.x_offset, self.y + anim.y_offset, anim.x_width, anim.y_width, self.left)
   if self.selected then
    spr(16, self.x, self.y)
   end
  end})
end

-- Merge two units
function merge(unit, other)
 new_type = 0
 if unit.unit_number == 1 and other.unit_number == 1 then
  -- RULE 1: Merge 1 and 1 into 2 or 3
  new_type = flr(rnd(2)) + 2
 elseif unit.unit_number == 2 and other.unit_number == 2 then
  -- RULE 2: Merge 2 and 2 into 4
  new_type = 4
 elseif unit.unit_number == 3 and other.unit_number == 3 then
  -- RULE 3: Merge 3 and 3 into 5
  new_type = 5
 elseif unit.unit_number == 6 and other.unit_number == 6 then
  -- RULE 4: Merge 6 and 6 into 7 or 8
  new_type = flr(rnd(2)) + 7
 elseif unit.unit_number == 7 and other.unit_number == 7 then
  -- RULE 5: Merge 7 and 7 into 10
  new_type = 10
 elseif unit.unit_number == 8 and other.unit_number == 8 then
  -- RULE 6: Merge 8 and 8 into 9
  new_type = 9
 end
 if new_type != 0 then
  del(units, unit)
  del(units, other)
  add_unit(unit.x, unit.y, new_type, true)
 end
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
	local vec = vec or {mx, my}
 return ((vec[1]+1) * 512) + vec[2]
end

function snap_mouse(c, mc)
 if (c-mc)%2 == 0 then
  return mc
 else
  return mc+1
 end
end

-->8

function add_particle(clr, x, y, r, dx, dy, lifespan)
	clr = clr or flr(rnd(16))
	x = x or 63
	y = y or 63
	r = r or flr(rnd(2.9))+1
	dx = dx or rnd(3)-1.5
	dy = dy or rnd(3)-1.5
	lifespan = lifespan or rnd(5)+5
	add(pcls, {
		x = x,
		y = y,
		r = r,
		dx = dx,
		dy = dy,
		life = lifespan,
		draw = function(self, x, y)
			x = x or self.x
			y = y or self.y
			circfill(x, y, self.r, clr)
		end,
		update = function(self)
			self.x += self.dx
			self.y += self.dy
			self.r -= 0.2
			self.life -= 1
			if self.life < 0 then
				self.dx = self.dx/1.5
				self.dy = self.dy/1.5
			end
			if abs(self.dx) < 0.05 and abs(self.dy) < 0.05 then
				del(pcls, self)
			end
		end})
end
__gfx__
00010000000010000000000000000007000001b0000000000009000000000000000000000000000000000000003cc00000000000000000000000000000000000
001c10000011b1100000b000000010c1001111b10000000000000099000ccc00000000000100001010ccc0013ccccc0000000000000000000000000000000000
0171710000100010000101000011b0c101bbbbb1009000000000009a00cc1c20000ccc000c0cc0c00c7dd7c003cc12c0000ee000000ee0000000000000000000
1c777c1001b070b10010701001bbbcc101bccc11000a099090aa000000ceec2000cc1c200c7dd7000ce22e0000cdd2000000e000000e00000000000000000000
c71717c0001000100b07070b1bbccc1001b77c100988aa900aaaaa000ccccc0000ceec200ce22e0000cccc000c0000c0000ee00ccccce0000000000000000000
77c1c7700011b110011111111b0c110011bbbc100a8a8aa0a88faa9000c000000ccccc000cccccc000c00c00cc0000cc000eecccccccc000000eeee000ee0000
1c101c1000001000000010001b0100001ccccc1099888a9998a899900000000000000000cc0000cc0cc00cc0c100001c000eccccc1cccc0000e0eeeccccce000
010001000000000000000000700000000c111100099a9999088899000000000000000000110000110110011010000001000cccc11ccc2c0000e00cccc1ccc000
bb0000bb000000000000000000000000000000000000000000a000000000000000000000000000999900000001000010000eccccccc222c00000cccccccccc00
b000000b00000000000000000000000000000000000a0000088faa00000000000008880000009999a99900001c0000c100cceeccccccccc0000cccc11ccc2c00
00000000000000000000000000000000000000000988aa0008a899a00888000000005880000999999a990000cc0000cc00cceeccdddcccc0000cccccccc222c0
00000000000000000000000000008000000000000a8a8aa0a8889a9a00588000000888800009999999990000c000000c00cccccddddddc0000ceccccccccccc0
00000000000000000000000000088800000080009a888a990a99a9a908888000000009900888889999990000c03cc0c0000ccccddddddc0000cceeccccccccc0
000000000000000000000000008a0a8000088800099a999909009009009900000000aa0080008889999900000cccccc0000cccdddddddc000ccceecccddccc00
b000000b00000000000000000099f990008a0a80990990900090090900aa000000aa0000080008899990000033cc1200000ccccccccccc00ccccccdddddddcc0
bb0000bb0000000000000000080000008099f99090090090009009090009aa0900900900008888999900000000cdd200000c001111000c00ccc1cdddddddddcc
0000000000000000000000000088800000888000000000000000000000000000000000000009499990000000000000000d000100000000000000000000000000
0000000000000000000000000000800000800000088800000008880000008888000000000094499900000000000000000ddd0011100000000000000000000000
00000000000000000000000000008000008000000098000000089000000800088000000009449990000000000000000000dddd01111000000000000000000000
000000000000000000000000000000000000000009080000000809000000800088990000094999099a900000000000000d0ddddd111100000000000000000000
0000000000000000000000008800000000000880099000000000990000000888889900000949909999a000000000000000ddccdd3c1100000000000000000000
0000000000000000000000000890000000009800009990080099900000000998899a90000949999999a00000000000000d0dddcddc3332200000000000000000
00000000000000000000000000099000009900000008999999980000000000999999a00009949999099000000000000000d0cddddc3773200000000000000000
0000000000000000000000000009989998990000000999aaa9999000000009449999900000944440009490000000000000dddd3cd3c3d3200000000000000000
000000000000000000000000008899898998800000999a88fa999900000099499999000000000000000000000000000000011c3cd3cc3020000ddddd3c110000
000000000000000000000000009999aaa999990009998a808a899990000094499990000000000000000000000000000000011c3c3c3002000ddd1dddc3c33322
00000000000000000000000009999a88fa9999900999aa888aa9999000094499900000000000000000000000000000000001113c3c0000000001ddddd3c37732
0000000000000000000000000998aa808aa8999009989999999899900094499009aaa0000000000000000000000000000011100000000000dddddddcd3cc3d32
0000000000000000000000000999aa888aa9999000999999999999000944990099999a0000000000000000000000000000111000001000000011ddcddc3c3302
000000000000000000000000098899999998890000000000000000000449909999999990000000000000000000000000001111111100000001111ddc3c3c0020
00000000000000000000000000000999990000000000000000000000949999999990094000000000000000000000000000011111100000000111013c3c000000
00000000000000000000000000000000000000000000000000000000944444949900009000000000000000000000000000000000000000000011111111000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000455555661455555400000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000555556001066655600000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000655660001001065600000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006000101001101000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000110011210100101000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010122221211211100000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012d2222e22221100000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000022222ee2de22de100000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012e212222222ed2ddee2d21e22e100
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001122de2222e22edd222dd2222d22de11
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000022222222ee22dd22222222222222220
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000122dee22de222222ee222ee22eeed10
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001e2dddddddee22eedde22dd22dddd10
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011dd2dd2ddddd22ddd22edd22eed2100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000122e2222d222222222d2222de22211
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011112d21e22222d222edd22d2122dd10
000000000000000000000000000000000000000000000000000000005554455555544445222ee2222eedd222000000000000000022222ee222ddd22200000000
00000000000000000000000000000000000000000000000000000000555554445449aaa522ddde222dde22220000000000000000122122221222212100000000
00000000000000000000000000000000000000000000000000000000555555495499999422ddd22de22222220000000000000000011001110011101000000000
00000000000000000000000000000000000000000000000000000000455555495544444522222222dd22222d0000000000000000001101000000001000000000
000000000000000000000000000000000000000000000000000000004555554444555555222deee2d22222220000000000000000000666066111111100000000
00000000000000000000000000000000000000000000000000000000a4555554aa445499de22dde2222222de0000000000000000056555655001165000000000
0000000000000000000000000000000000000000000000000000000094555554999454992222ddd22222ee2d0000000000000000655555555660654600000000
00000000000000000000000000000000000000000000000000000000944555554445554422222222222ddd2d0000000000000000555444555440554900000000
00000000000000000000000000000000000000000000000000000000aa944445545554452edee22222eddd22000000000006546555549a454996554455644600
00000000000000000000000000000000000000000000000000000000445555554a4559942ddde2222222d22d000000001165599455549a45444555455449aa61
00000000000000000000000000000000000000000000000000000000555555459a4549942ddddee22222222200000000006549945549995555559aa554999600
00000000000000000000000000000000000000000000000000000000555555559a4549a422ddddd22222222200000000164549a455444455554999a455444460
0000000000000000000000000000000000000000000000000000000055555555445549a4222dddd22222222200000000065549a4555555555549999444555561
0000000000000000000000000000000000000000000000000000000055555555555544452de2dd22222222220000000000654445455549a555444445aa445490
0000000000000000000000000000000000000000000000000000000055445555455555442dd2222d22edde2200000000065555444555499a4555555599945600
00000000000000000000000000000000000000000000000000000000549994459455555522de2e222eddddd20000000011655555555449944994555544455611
__gff__
0000000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
007e677e6868687e7e7e7e687777777e07000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0067676767687e7d4d4e7d7d7777777800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
006767676868684d5d5d4e7d7d7d7e7d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007d676868684d5d5e5e5e4e4e4e4d4e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007d7d7d4d4d5d5d5d5d7a79795d5d5d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
004d4e4d5d5e7a5d7a5d5d7a696a5d7900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
005d5d5e5e7a7a5d5d5d5d5d795e5e5d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000076263795d5d5d6a7a7a5e5e630000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000007273727372737262727372730000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000626362636363626263626362630000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000727363737373727273727372730000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000007273006263006263000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000007273007273000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
