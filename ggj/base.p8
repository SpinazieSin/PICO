pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function _init()
  units={}
  base={
    center_x=0,
    center_y=0,
    edges={
        {0,0}
    }
  }
end

function update_base()
 -- nothing in base[3]???
    for edge in all(base[3]) do
        printh("NO")
        mset(1, 0, 2)
    --     mset(edge[1], edge[2]+1, 2)
        -- add(edges, {edge[1]+1, edge[2]})
    end
end

function pix2tile(x,y)
    return {flr(x/8),flr(y/8)}
end

function add_unit(_x,_y)
  add(units, {
      x=_x,
      y=_y,
      health=100, -- percentage
      speed=2, -- how many frames before moving one tile
      sprite_id=2,
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
    cls()
    for unit in all(units) do
        unit:draw()
    end
    map(0,0,0,0,16,16)
    mset(0,0,1)
    update_base()

end


__gfx__
00000000aaaaaaaacccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000aaaaaaaacccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700aaaaaaaacccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000aaaaaaaacccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000aaaaaaaacccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700aaaaaaaacccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000aaaaaaaacccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000aaaaaaaacccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
