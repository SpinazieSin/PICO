pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
--
function _init()
 units = {}

 plrx = 63
 plry = 63
	add_player()
end

function _update()
 
 for unit in all(units) do
  unit:update()
 end
end

function _draw()
 cls()
 map()

 for unit in all(units) do
  unit:draw()
 end
end

-->8
--
function add_player(x, y)
 local x = x or 63
 local y = y or 63

 local dx = 0.5
 local dy = 0.5

 local sprite = 67

 local shdw = {x = 4, y = 8, r = 2}

 add(units, {

   -- unit traits --
   x = x,
   y = y,
   dx = dx,
   dy = dy,
   sprite = sprite,
   shdw = shdw,

   -- update the unit --
   update = function(self)
    if btn(5) then
     self.x += self.dx
     self.y += self.dy
    end
   end,

   -- draw the unit --
   draw = function(self)
     spr(self.sprite, self.x, self.y)
   end,

   -- draw the shadow --
   shadow = function(self)
    local shdw = self.shdw
    circfill(self.x + shdw.x, self.y + shdw.y, shdw.r, 0)
   end
  })
end

__gfx__
8800008822222222ccaaccccaaaaaaaa0005040055555655556566ee555555550005050000000000000050555055555066666666666767666666666600006066
8880008822222222ccaaccccaaaaaaaa00054000e565565555555555555555555000050005550005555555555055505066666666766667666777666766666666
0888088022222222ccaaccccaaaaaaaa0005000065555e5556e65655555555555050050000000000050055505055505066666666767667666666666606006660
0008888022222222aaaaaaaaaaaaaaaa003500006565565555555555555555555050000000005550555555555050505566666666767666666666777666666666
0088800022222222aaaaaaaaaaaaaaaa0004000055e5555555656e65555555550050500000000000500050055050555566666666667676666666666660006006
0880888022222222ccaaccccaaaaaaaa0004000055e5555655555555555555550050005055505000555555555550505566666666667666767776766666666666
8880088822222222ccaaccccaaaaaaaa00054000556565566e566565555555550000005000000000505000005050555566666666666666766666666660600000
8800008822222222ccaaccccaaaaaaaa000550005555555e55555555555555555000505000005555555555555550555066666666766676766666777766666666
00000000000000000500000077757477000500004445454444444444444444440004040000000000446466ee4444464477777777666f6f666666666660666660
0000000000000000f56600007775477700050500544445444555444544444444400004000444000444444444e464464477ddd777f6666f666fff666f60666060
0000000000000000050000007775777705040500545445444444444444444444404004000000000046e6464464444e447ddddd77f6f66f666666666660666060
000000000000000000000000773577770054000054544444444455544444444440400000000044404444444464644644dd1d1dd7f6f666666666fff660606066
0000000000000000000000007774777700040000445454444444444444444444004040000000000044646e6444e44444d81d18dd66f6f6666666666660606666
000000000000000000000000777477770005400044544454555454444444444400400040444040004444444444e444467ddddddd66f666f6fff6f66666606066
000000000000000000000000777547770035400044444454444444444444444400000040000000006e4664644464644688ddd887666666f66666666660606666
00000000000000000000000077755777303545305444545444445555444444444000404000004444444444444444444e88878887f666f6f66666ffff66606660
00000000000000000000000077757777cccccccc11111c1111c1cccc111111110001010000000000000010111011111000000000000000000000000000000000
00000000000000000000000077757577ccccccccc1c11c1111111111111111111000010001110001111111111011101000000000000000000000000000000000
00000000000000000000000075747577ccccccccc1111c111ccc1c11111111111010010000000000010011101011101000000000000000000000000000000000
00000000000000000000000077547777ccccccccc1c11c1111111111111111111010000000001110111111111010101100000000000000000000000000000000
00000000000000000000000077747777cccccccc11c1111111c1ccc1111111110010100000000000100010011010111100000000000000000000000000000000
00000000000000000000000077754777cccccccc11c1111c11111111111111110010001011101000111111111110101100000000000000000000000000000000
00000000000000000000000077354777cccccccc11c1c11ccc1cc1c1111111110000001000000000101000001010111100000000000000000000000000000000
00000000000000000000000037354537cccccccc1111111c11111111111111111000101000001111111111111110111000000000000000000000000000000000
00007077707777700007070000000000777777773333313333131111333333330003030000000000000030333033333000000000000000000000000000000000
77777777707770707000070007770007777777771313313333333333333333333000030003330003333333333033303000000000000000000000000000000000
07007770707770707070070000000000777777771333313331113133333333333030030000000000030033303033303000000000000000000000000000000000
77777777707070777070000000007770777777771313313333333333333333333030000000003330333333333030303300033000000000000000000000000000
70007007707077770070700000000000777777773313333333131113333333330030300000000000300030033030333300300300000000000000000000000000
77777777777070770070007077707000777777773313333133333333333333330030003033303000333333333330303373000030000000000000000000000000
70700000707077770000007000000000777777773313133111311313333333330000003000000000303000003030333330000003000000000000000000000000
77777777777077707000707000007777777777773333333133333333333333333000303000003333333333333330333000033007000000000000000000000000
00020000000000000000020000000000000200000000000000000000000000000000000000000055550000000004676474664e044100000000000000000eee00
002d20000002000000002d2000000200002d200000000000000000000007770000000000000005555550000040454666666466401400000000020000000eee00
026f6200002d2000000222d200002d2002ddd200000000000000000007777770000000000555551555550060045454646644640441600000002d200000cccc00
00626000026f62000000d6f0000222d20062600000000000000000000088880000000000055515515555660040454064646406451466000002ddd2000d5c5cd0
02ddd20000626000002dd600000dd6f002ddd200000000000000000000888800000000000055077155666660040044040005445516666660006260000d5222d0
02ddd20002ddd200002ddd00002dd60002ddd20000000000077777777777777770000000000755755666640405050045555055050556666002ddd2000f0202f0
022d2200022d220002ddd20002ddd200022d2200000000007777777777777777770000006007657566664640055411555455114400056660022d220000020200
22222220222222202222220022222220222222200000000757777777777777757770000006676475664644040541551444115444000666002222222000050500
000eee00000eee000000000000eee0000000000000000075887777777777777870770000000000060000660004155551115545540066600000000000000eee00
000efe00000efe00000eee0000fee00000eee000000007588887777777777758870770000000066600066660015555155554554406666000000eee00000eee00
00dcccc000dcccc0000efe0000cccc0000fee0c0000075777788777777777177777077700550666500066666000051515555545066666600000eee0000cccc00
00dc5c5d00dc5c5d00dcccc0005cd0c000cccc00000757dd8d888777775587777707777044666655066666660000051515555556666666000dccccd00d5c5cd0
00d2225d00d2225d00dc5c5d0022d000005cd000077588dd8d8888777d5588d5d111110066666551066ff4650006665155555556666066600d5c5cd00d5222d0
00f2020f00f2020f00f2020f0002f000002d000007078888888888758d5577777707070060066600000ff4500666666515515100056060600f0202f00f0202f0
00020200000502000002050000020000020f0000000788dd8d8888788d7775555117070000665000000000000600000151516600055455000002050000050200
00050500000005000005000000050000050050000007887777888878775577777707770000000000000000006066660000666660000000000005000000000500
000eee0000000000000eee000000000000eee00000077787877778778555777777177700000000000000000000000000000eee000000000000000000000eee00
000efe00000eee00000efe00000eee0000fee000000788888888878888857588780787000000000000000000000000000f0efe0f00eee000000eee00000eee00
000ccc00000efe00000ccc00000efe0000cccc00000787777788878777757855758787000000000000000000000000000d0ccccd00fee0c0000eee00000ccc00
00cd2dc00f0ccc0f00cd2dc0000ccc0000d2ddc0000788dd8d888788d8d578557587870000000000000000000000000000dc5c5d00cccc0000ccccc000cdddc0
0fdd2ddf00cd2dc00fdd2ddf0fcd2dcf00d2dddf000788dd8d888788d8d57855758787000000000000000000000000000002225000d2dddf0fdddddf0fdddddf
0022222000dd2dd0002222200022222000222220000788dd8d888788888578557577870000000000000000000000000000020200002222200022222000222220
00050500002222200005050000050500005005000007888888888788d8d577777787770000000000000000000000000000020200005050000005050000050500
0005050000050500000005000005000000000050000788dd8d888788d8d578577787870000000000000000000000000000050500005000000005000000000500
00000000000000000000000000000000000000000007877777888788777578878777870000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000007888888888788888777775757777700000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000007888888888788777777775757777700000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000007777777777777777777711155777700000000000000000000000000000000000000000000000000000000
000eee00000eee00000eee0000eee00000eee00007117777777777777777771777777777000000000000000000000000000eee00000eee00000eee00000eee00
000efec0000efec0000efec000feec0000feec007777717777777777777777777777777700000000000000000000000000fefef000ceee00000eeec000ceee00
00fcccf000fcccf000fcccf000cccf0000cfc00077777777777777777777777777777711000000000000000000000000000ccc0000fcccf000fcccf000fcccf0
00050500000500000000050000050000005000007777777777777777777777777771777700000000000000000000000000050500000505000005000000000500
__map__
3334343300040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3234343200144546474804320032323333333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3130343133005556575804323234343431343433000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0031343434336566676814323434343434343434000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0032343434347576777834313031343434343434000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3231303434343434343434343434343434343434333400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0033313434343434343434343434343434343433343400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3232343434343434343434343434343434343431303400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3231343434343434343434343434343434343400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3234313434343434343434343434313431313100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3230313434343434343434343431333331303400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000323434343434343434343430333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000313031343431303431303030320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0032313132323031313433303233320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000323200003232323333330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000