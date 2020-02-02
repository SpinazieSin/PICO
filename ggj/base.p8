pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

printh("========================")

function _init()
  units={}
  base={
    center_x=0,
    center_y=0,
    edges={{3,0},{0,1},{1,1},{2,1},{3,1}}
  }
  startcounter = 0
  resumeTime = time()
  red_cells = {103,104,119,120}
  pur_cells = {105,106,121,122}
  edge_cells = {77,78,109,110,92,95,124,127}
  -- red_edge en pur_edge not sure about how to use these now
  red_edge = {124,125,126,127}
  pur_edge = {92,93,94,95,78,77}
  -- all cells that can be changed by units
  red_all_cells = {103,104,119,120,124,125,126,27,109,110}
  pur_all_cells = {105,106,121,122,92,93,94,95,78,77,109,110}
  player_faction = 'b'
  if player_faction == 'a' then 
    -- set player colors
    pfaction_cells=pur_cells
    pfaction_edge=pur_edge
    pfaction_all_cells=pur_all_cells

    -- set enemy colors
    efaction_cells = red_cells
    efaction_edge = red_edge
    efaction_all_cells=red_all_cells
  else 
    -- set player colors
    pfaction_cells = red_cells
    pfaction_edge = red_edge
    pfaction_all_cells=red_all_cells

    -- set enemy colors
    efaction_cells = pur_cells
    efaction_edge = pur_edge
    efaction_all_cells=pur_all_cells
  end
end

function is_in(a,list)
-- is elemnt a in list b?
    for elem in all(list) do
        if elem == a then
            return true
        end
    end
    return false
end

function subset(list, length)
-- take subset of list, length needs to be less than the length of the list
    new_list = {}
    used_idx = {}
        for k = 1,length do
            idx_rcell = flr(rnd(count(list)))+1
            printh(not(is_in(idx_rcell, used_idx)))
            if not(is_in(idx_rcell, used_idx)) then
                add(new_list,list[idx_rcell])
                add(used_idx,idx_rcell)
            end
        end
    return new_list
end

function get_orientation(edge)
    -- get the orientation for a cell
    -- get cell values 
    left = mget(edge[1]-1,edge[2])
    top = mget(edge[1],edge[2]-1)
    right = mget(edge[1]+1,edge[2])
    bottom = mget(edge[1],edge[2]+1)
    diag_br = mget(edge[1]+1,edge[2]+1)
    diag_bl = mget(edge[1]-1,edge[2]+1)
    diag_tl = mget(edge[1]-1,edge[2]-1)
    diag_tr = mget(edge[1]+1,edge[2]-1)

    -- check if cell values are 
    left = is_in(left, pfaction_all_cells)
    top = is_in(top, pfaction_all_cells)
    right = is_in(right, pfaction_all_cells)
    bottom = is_in(bottom, pfaction_all_cells)
    diag_br = is_in(diag_br, pfaction_all_cells)
    diag_bl = is_in(diag_bl, pfaction_all_cells)
    diag_tl = is_in(diag_tl, pfaction_all_cells)
    diag_tr = is_in(diag_tr, pfaction_all_cells)

    if not(bottom) and not(diag_bl) and not(diag_br) then


end


function check_cell_clear(edge)
    -- get cell values 
    left = mget(edge[1]-1,edge[2])
    top = mget(edge[1],edge[2]-1)
    right = mget(edge[1]+1,edge[2])
    bottom = mget(edge[1],edge[2]+1)
    diag_br = mget(edge[1]+1,edge[2]+1)
    diag_bl = mget(edge[1]-1,edge[2]+1)
    diag_tl = mget(edge[1]-1,edge[2]-1)
    diag_tr = mget(edge[1]+1,edge[2]-1)

    -- check if cell values are 
    left = is_in(left, pfaction_all_cells)
    top = is_in(top, pfaction_all_cells)
    right = is_in(right, pfaction_all_cells)
    bottom = is_in(bottom, pfaction_all_cells)
    diag_br = is_in(diag_br, pfaction_all_cells)
    diag_bl = is_in(diag_bl, pfaction_all_cells)
    diag_tl = is_in(diag_tl, pfaction_all_cells)
    diag_tr = is_in(diag_tr, pfaction_all_cells)

    -- check if any of the tiles are outside the map
    if (edge[1]-1) < 0 then left = true end
    if (edge[2]-1) < 0 then top = true end
    if (edge[1]+1) > 63 then right = true end
    if (edge[2]+1) > 63 then bottom = true end
    if (edge[1]+1 > 63 and edge[2]-1 < 0) then 
        diag_ne = true 
    end 
    if (edge[1]-1 < 0 and edge[2]+1 > 63) then 
        diag_sw = true
    end
    if (edge[1]-1 < 0 and edge[2]-1 < 0) then 
        diag_nw = true 
    end
    if (edge[1]+1 > 63 and edge[2]+1 > 63) then 
        diag_se = true 
    end
    
    -- return true if cell is surrounded, false otherwise
    if left and top and right and bottom and diag_br and diag_bl and diag_tl and diag_tr then
        return true
    else
        return false
    end
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end


function update_base(points_to_update, unit_update)
    local unit_update = unit_update or false
    local points_to_update = points_to_update or {}
    
    local new_edge = {}
    local used_edges = {}
    printh(count(base.edges))
    -- loopable_edges = deepcopy(base.edges)

    -- loop over all edges
    for edge in all(base.edges) do
        printh("in loop 1")
        -- useless if statement
        if unit_update then
            printh("in unit update")
            -- loop over cells to be updated
            for cell in all(points_to_update) do
                -- match the cell with a known edge
                if cell[1] == edge[1] and cell[2] == edge[2] then
                    printh("points match!")
                    -- set the new cells blue and add them to the edge list
                    -- where to add
                    rando = rnd(1)
                    -- what random piece to get
                    idx_rcell = flr(rnd(count(edge_cells)))+1
                    rcell = edge_cells[idx_rcell]
                    if rando > 0.25 and rando < 0.5 then
                        if not(is_in(mget(edge[1], edge[2]+1), pfaction_all_cells)) then
                            mset(edge[1], edge[2]+1, rcell)
                            add(new_edge, {edge[1], edge[2]+1})
                        end
                    elseif rando > 0.5 and rando < 0.75 then
                        if not(is_in(mget(edge[1]+1, edge[2]), pfaction_all_cells)) then
                            mset(edge[1]+1, edge[2], rcell)
                            add(new_edge, {edge[1]+1, edge[2]})
                        end
                    elseif rando < 0.25 then
                        if not(is_in(mget(edge[1]-1, edge[2]), pfaction_all_cells)) then
                            mset(edge[1]-1, edge[2], rcell)
                            add(new_edge, {edge[1]-1, edge[2]})
                        end
                    elseif rando > 0.75 then
                        if not(is_in(mget(edge[1], edge[2]-1), pfaction_all_cells)) then
                            mset(edge[1], edge[2]-1, rcell)
                            add(new_edge, {edge[1], edge[2]-1})
                        end
                    end
                break

                end
            end
        end
    end
    -- add(base.edges, new_edge)
    -- add(base.edges, points_to_update)
    local tmplist = {}
    -- printh("length of base edges")
    -- printh(count(base.edges))
    for new_e in all(new_edge) do
        add(base.edges, {new_e[1],new_e[2]})
    end
    -- add(base.edges, new_edge)
    printh(count(base.edges))
    for edge in all(base.edges) do
        printh("checking edge")
        if check_cell_clear(edge) then
            printh("edge clear!")
            idx_rcell = flr(rnd(count(pfaction_cells)))+1
            mset(edge[1], edge[2], pfaction_cells[idx_rcell])
            -- printh("edge surrounded")
        else
            -- printh("edge not surrounded")
            add(tmplist, {edge[1], edge[2]})
        end
    end
    base.edges = tmplist
    printh(count(base.edges))
    -- stop()
end

function pix2tile(x)
    return flr(x/8)
end

function tile2pix(x)
    return x*8
end

function add_unit(_x,_y)
  add(units, {
      x=_x,
      y=_y,
      health=100, -- percentage
      speed=2, -- how many frames before moving one tile
      sprite_id=7,
      type=1,
      draw=function(self)
        spr(self.sprite_id, self.x, self.y)
      end,
      update=function(self)
        if (btn(0)) then
            self.x -= self.speed
        end
        if (btn(1)) then
            self.x += self.speed
        end
        if (btn(2)) then
            self.y -= self.speed
        end
        if (btn(3)) then
            self.y += self.speed
        end

        table = {}

        -- check for areas to grow
        if rnd(1) < 0.05 then
            points_to_update = {}
            tx = pix2tile(self.x)
            ty = pix2tile(self.y)
            printh("getting edge cells near unit!")
            for i=tx-1,tx+1 do
                for j=ty-1,ty+1 do
                    if is_in(mget(i, j), edge_cells) then
                        add(points_to_update, {i,j})
                        printh("-----------")
                        printh(i)
                        printh(j)
                    end
                end
            end
            printh("n cells will be passed")
            printh(count(points_to_update))
            update_base(points_to_update, true)
        end
      end
  })
end


function _update()

    for unit in all(units) do
        unit:update()
    end
    if btn(5) then
        add_unit(64,64)
    end
end

function _draw()
    -- if(time() < resumeTime) return
    cls()
    map(0,0,0,0,16,16)
    -- mset(0,0,2)
    -- if startcounter < 7 then
    --     update_base()
    --     startcounter += 1
    -- end
    for unit in all(units) do
        unit:draw()
    end
    print("mem:"..stat(0), 0, 0)
    print("cpu:"..stat(1), 0, 8)
end

__gfx__
00010000000010000000000000000007000001b0000000000009000000000000000000000000000000000000003cc00000000000000000000000000000000000
001c10000011b1100000b000000010c1001111b1000000000000009900000000000000000100001010ccc0013ccccc0000000000000000000000000000000000
0171710000100010000101000011b0c101bbbbb1009000000000009a00000000000000000c0cc0c00c7dd7c003cc12c0000ee000000ee0000000000000000000
1c777c1001b070b10010701001bbbcc101bccc11000a099090aa0000000ccc00000000000c7dd7000ce22e0000cdd2000000e000000e00000000000000000000
c71717c0001000100b07070b1bbccc1001b77c100988aa900aaaaa0000cc1c20000ccc000ce22e0000cccc000c0000c0000ee00ccccce0000000000000000000
77c1c7700011b110011111111b0c110011bbbc100a8a8aa0a88faa9000ceec2000cc1c200cccccc000c00c00cc0000cc000eecccccccc000000eeee000ee0000
1c101c1000001000000010001b0100001ccccc1099888a9998a899900ccccc0000ceec20cc0000cc0cc00cc0c100001c000eccccc1cccc0000e0eeeccccce000
010001000000000000000000700000000c111100099a99990888990000c000000ccccc00110000110110011010000001000cccc11ccc2c0000e00cccc1ccc000
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
__map__
6878777f6a6a6a6a6a6a6a6a6a6a6a6a07000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4d4e4d4d6a6a6a6a6a6a6a6a6a6a6a6a6a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6a6a6a6a6a6a6a5d5e6a6a6a6a6a6a6a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6a6a6a6a6a6a6a5d5d5d7a796a6a5d5d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6a6a6a6a6a6a7a5d7a5d5d7a696a5d7900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
005d5d5e5e7a7a5d5d5d5d5d795e5e5d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000076263795d5d5d6a7a7a5e5e630000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000007273727372737262727372730000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000626362636363626263626362630000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000727363737373727273727372730000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000007273006263006263000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000007273007273000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
