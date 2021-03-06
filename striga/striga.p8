pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- game function --
function _init()
 plr_x = 100
 plr_y = 450
 sprint_speed = 1

 units = {}
 add_unit()
end

function _update()
 plr_dx = 0
 plr_dy = 0
 if btn(0) then
  plr_x -= sprint_speed
 end
 if btn(1) then
  plr_x += sprint_speed
 end
 if btn(2) then 
  plr_y -= sprint_speed
 end
 if btn(3) then
  plr_y += sprint_speed
 end

 for unit in all(units) do
  unit:update()
 end

 camera(plr_x-63, plr_y-63)
end

function _draw()
 cls()
 map(0, 0, 0, 0, 128, 128)

 for unit in all(units) do
  unit:shadow()
 end

 for unit in all(units) do
  unit:draw()
 end

 spr(2, plr_x, plr_y)
end
-->8
-- unit function --

-- the function to add all functions --
function add_unit(x, y)
 -- set default unit traits
 local x = x or plr_x - 20
 local y = y or plr_y - 20

 local dx = 0.5
 local dy = 0.5

 local sprite = 96

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
    -- circfill(self.x + shdw.x, self.y + shdw.y, shdw.r, 0)
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
00000000000000000000000000000000000500004445454444444444444444440004040000000000446466ee4444464477777777666f6f666666666660666660
0000000000000000000000000000000000050500544445444555444544444444400004000444000444444444e464464477ddd777f6666f666fff666f60666060
0000000000000000000000000000000005040500545445444444444444444444404004000000000046e6464464444e447ddddd77f6f66f666666666660666060
000000000000000000000000000000000054000054544444444455544444444440400000000044404444444464644644dd1d1dd7f6f666666666fff660606066
0000000000000000000000000000000000040000445454444444444444444444004040000000000044646e6444e44444d81d18dd66f6f6666666666660606666
000000000000000000000000000000000005400044544454555454444444444400400040444040004444444444e444467ddddddd66f666f6fff6f66666606066
000000000000000000000000000000000035400044444454444444444444444400000040000000006e4664644464644688ddd887666666f66666666660606666
00000000000000000000000000000000303545305444545444445555444444444000404000004444444444444444444e88878887f666f6f66666ffff66606660
00000000000000000000000000000000cccccccc11111c1111c1cccc111111110001010000000000000010111011111000000000000000000000000000000000
00000000000000000000000000000000ccccccccc1c11c1111111111111111111000010001110001111111111011101000000000000000000000000000000000
00000000000000000000000000000000ccccccccc1111c111ccc1c11111111111010010000000000010011101011101000000000000000000000000000000000
00000000000000000000000000000000ccccccccc1c11c1111111111111111111010000000001110111111111010101100000000000000000000000000000000
00000000000000000000000000000000cccccccc11c1111111c1ccc1111111110010100000000000100010011010111100000000000000000000000000000000
00000000000000000000000000000000cccccccc11c1111c11111111111111110010001011101000111111111110101100000000000000000000000000000000
00000000000000000000000000000000cccccccc11c1c11ccc1cc1c1111111110000001000000000101000001010111100000000000000000000000000000000
00000000000000000000000000000000cccccccc1111111c11111111111111111000101000001111111111111110111000000000000000000000000000000000
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
0000000000000093a3a3a3a3a3a3a393009292929292626262626242424242424242424242424242424242004242423030424242424242424200424242424242
4242424242426292920000d1d0230000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00c3c300000093a363737373737363a39300c3c30092926262626242424242424242424242424242424242004242423030424242424242424200424242424242
4242424242626292002323d0d0232340000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000093a373737373737373a3930000000000929292626242424242424242424242424242424242004242423030424242424242424200424242424242
4242424242626292000023d0d0230040c3c3c3c30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000093a3637373737373737363a39300000000929292926242424242424242424242424242424242003030303030303030303030303000424242424242
4242424242426292c3c300c0c0230040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00c3c3c30093a3636373737373736363a3930000c3c3000092926242424242424242424242424242424242003030303030303030303030303000424242424242
4242424242426292000000c0d1004041000040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000093a3637373737373737363a39300000000929292926242424242424242424242424242424242004242423030424242424242424200424242424242
4242424242426292920000c0d1004000000040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000093a3637373737373737363a39300000000009262424242424242424242424242424242424242004242423030424242424242424200424242424242
4242424242626292929200d1d10041c3c30041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000c3c3c30093a353537373735353a39300c3c3c300000092624242424242424242424242424242424242004242423030424242424242424200424242424242
4242424242426292920000c0c0000000c3c3c3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000009282b263535353639200000000000000009292926242424242424242424242424242424242004242423030424242424242424200424242424242
4242424242426292920000d1c0000000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000929282b2b2b253b2b2b282920000000000000000926242424242424242424242424242424242000000000000000000000000000000424242424242
424242424242629240c300c0c0000000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000082a2b2b2b2b272b2828292920000c3c3c3c3009262424242424242424242424242424242424242424242424242424242424242424242424242
4242424242626292404000d0c000c300410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000c3c3c3c3c39282a2b2b272727272a292920000000000929262624242424242424242424242424242424242424242424242424242424242424242424242
4242426262629292404123d0d000000000c3c3004000000000000000400000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000009282b272727272a292929200009200926262626242424242424242424242424242424242424242424242424242424242424242626262
6262626262929292410023d0d02300c3c3c300004000000000000000400000000000000000000000000000000000000000000000000000000000000000000000
000000000000c3c340929282a2a2a2b272728200c3c3000000009262626262626242424242424242424242424242424242424242424242424242626262626292
6292929292929200002323d0c0000000000000004000005464742000404000000000000000000000000000000000000000000000000000000000000000000000
000000004000000040000000929282b2b27282820000000000929262626262626262626262424242424242424242424242424242424242424242629292929292
9200000090009200004023c0d1c00000c30000004133005565758500404000000000000000000000000000000000000000000000000000000000000000000000
0000000040c3c30040400054647484b2b2b282820000000000000092929292929292929292629262424242424242424242424242424242424262629200900000
9200009090909000004100c0c0c0e1000000003333330056667686004140c3c3c300000000000000000000000000000000000000000000000000000000000000
c3c300404000000041400055657585f1f1b282000000400000000000009200929262626262626262626242424242424242424242424242426262929290909090
909090909090909090900000d1e1e1e1e1e1e0e0e03333576777873333410000c3c3000000000000000000000000000000000000000000000000000000000000
0040004040c3c3c3c3409256667686c0c0b2826474844000c3c30000400000009292929292929292926242424242424242424242424242626262926060606060
606060606060606060600000d1d1e100000033330303030303030303333333000000000000000000000000000000000000000000000000000000000000000000
004000414154647484419257677787c0f1b255657585404000c3c3c340c3c3000092929200000000926242424242424242424242426262626292927070707070
707050707070707070708000d1d10000003390003333333333333333333300000000000000000000000000000000000000000000000000000000000000000000
0040c3c39255657585001343431300c0c0f1566676864141000000004000000000000000c3c3c392926262626262626262626262626262629292927070707070
707050707070707070708080d1d10090909090909090909090909000000000000000000000000000000000000000000000000000000000000000000000000000
404000929256667686f1e0e0e0e0e0c0c0e057677787033300000000414000c3c3c3c3c3c300000092929292929292929292929292929292929200b070707070
707050707070707070b08000d1d1a0606060606060606060606060a0909000000000000000000000000000000000000000000000000000000000000000000000
404192a2a257677787c0c0c0e0c0c0c0c0e1c0c0e0e003033333000000410000000000000000000000000000929292929292929200000000000080b070707070
707050707070707070b08000d1d1a0707070707050707070707050a0909090000000000000000000000000000000000000000000000000000000000000000000
4192a203434343430303e0c0c0c0c0c0c0c0c0c0c0e0c0c0e1c0c0c0e1c0c0e1c0e0e0e1c000000000000000000000920092000000000000000080b070707070
707050707070707070b00000d1d1a0707070707050707070707050a0909090000000000000000000000000000000000000000000000000000000000000000000
003303434372a254647484c0c0c0f1f1c0e0e0e0e0e0e0e0c0c0c0e1e1c0c0c0c0c0e0c0c000000000000000000000000000000000000000008080b070707070
7070507070707070a0a08000d1d1a0707070707050707070707050a0909000000000000000000000000000000000000000000000000000000000000000000000
0092a24343729255657585c0c0f1546474843303e0e003333300000000000000c0e0e0e0c000000000000000000000000000000000000000000080b070707070
70705070707070a0a0809000d1d1a0707070707050707070707050a0900000000000000000000000000000000000000000000000000000000000000000000000
333303434343a256667686c0c0c0556575850033333333330000000000404100c0c0c0e0e0e1c0c0c0e0c0c0c0e1e1e1c0e0c0c0c00000000000806060606060
60606060606060609054647484d1a0707070707050707070707050a0900000900000000000000000000000000000000000000000000000000000000000000000
0000330343434357677787e0c0c056667686000000333300000000000041000000000000c0c0e1c0c0c0e0e0c0c0e1e1c0e0e0e0e00000000000009090909090
909090333333c3c3c355657585d1a0606060606050606060606050a0900000000000000000000000000000000000000000000000000000000000000000000000
0092a233434343434343a2a2f1a25767778733000000000000c3c3c3c3c3c30000000000000000000000000000000000c0c0c0e0e0e0e0c0c0c0e1c0c0c0e1e1
e1c0c0e0030303330056667686d1a0707070707050707070707050a0909000000000000000000000000000000000000000000000000000000000000000000000
009272330343434343434343434343434343033300000000c3c3c3000000c300000000000000000000000000000000000000c0e0e0e0e0e0e0e0e0c0c0c0c0c0
e1c0e1c0c0e0e0e03357677787d1a0707070707050707070707050a0909000000000000000000000000000000000000000000000000000000000000000000000
9292a27233334343434303a2a243434343434303330000c300000000000000c30000000000000000000000000000000000000000000000000000000000000000
0000003303033303030303033390a0707070707050707070707050a0909090000000000000000000000000000000000000000000000000000000000000000000
0092a2a272727233033392929292720303a292920000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000333300003333c3009090a0707070707050707070707050a0909000000000000000000000000000000000000000000000000000000000000000000000
000092929292929292a27272727272a2a2a292000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000909090a0707070707050707070707050a0900000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0200000000000000020200000000000000000000000000000202000000000000000000000202020002020000000000000000020200000000020200000200000000000000000200000002020200020000000000000002020202020200000000000000000000020202020000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
2524242424242425283939000039000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000282828252525252424242424242424242424242424242424242424242424242424252525282828280000000000000000000000000000000000000000000000000000000000
2424242424242528290000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002828282525252424242424242424242424242424242424242424242424242424252525282828000000000000000000000000000000000000000000000000000000000000
2424242424252528121100000000000000330000000000000000000000000027270000000027272727272727272727272727272727000000000000000028282825252424242424242424242424242424242424242424242424242424252525282800000000000000000000000000000000000000000000000000000000000000
2524242424252528120000000000000033333300000000000000000000000027272727272727272727272727272727272727272727000000000000000000282825252424242424242424242424242424242424242424242424242424252525282800000000000000000000000000000000000000000000000000000000000000
2524242424242528290000000000333333333333000000000000000000000027272727272727272727272727272700000000272727000000000000000000002828252424242424242424242424242424242424242424242424242424252525282800000000000000000000000000000000000000000000000000000000000000
2525242424242425280000003333333030303033333300000000000000000027272727272727272727000000000000000000272727000000000000282727272728252424242424242424242424242424242424242424242424242424252528280000000000000000000000000000000000000000000000000000000000000000
2525252424242425280000333333303434343430333333000000000000002727272727272727272727000000002727272727272727000000272727272727272728252424242424242424242424242424242424242424242424242424252528000000000000000000000000000000000000000000000000000000000000000000
2525242424242425280033333330343434343434303333330000000000002727272727272727272727000000002727272727272727000000272727000000002b28252424242424242424242424242424242424242424242424242424252828000000000000000000000000000000000000000000000000000000000000000000
25242424242425252800000009343434494a3434340900000000000000002727272727272727272727000000272727272727272727000000272727000000002b28252424242424242424242624242424242424242424242424242424252800000000000000000000000000000000000000000000000000000000000000000000
242424242425252528000000003434344b4c4d34343027272727272727272727272727272727272727000000272727000000000000000028272727272727272b28252424242424242424262626242424242424242424242424242426252800000000000000000000000000000000000000000000000000000000000000000000
242424242425252528000000003434595b5c5d3434092727272727272727272727272727272727272700000027270000000000000000002827272727272727272b252624242424242426262626262424242424242424242424242626252800000000000000000000000000000000000000000000000000000000000000000000
242424242424252528000000000934343434343409000000000000000000272727272727272727272700000027270000000000000000002827270000000000002b282626262424242626262626262424242424242424242424262626282800000000000000000000000000000000000000000000000000000000000000000000
2524242424242425280000000009093434343409090000000000000000002727272727272727272700000000272700000000000000000027272700000000002827282828282424242426282828252424242626262626262626262628280000000000000000000000000000000000000000000000000000000000000000000000
2524242424242525280000000000000031310000000000000000000000000027272727272727272700000000272700000000000000000027272800000000000027000028282624242424262828252424242528282828282828282828000000000000000000000000000000000000000000000000000000000000000000000000
2524242424242528290000000000000031310000000000000000000000000027272727272727272700000000272727272727000000000027272700000000280027280000282826242424242428252424242528000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2424242424242528000000000000000027270000000000000000000000000027272727272727272700000000272727272727000000000027272700000037373737373700002828262424242424242424242528000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2424242424252829000000000000000027270000000000000000000000000027272727272727272700000000272727272727000000000027272700003737373737373737370028282626242424242424242528000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2424242424252800000000000000000027270000000000000000000000000027272727272727270000000000272727272727272727272727272700003737373737373737370000002828262626262624242528000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
242424242425280000000000000000002727272727270000000000000000002727272727000027000000000000000027272727272727272727000000373737373737373737360f1e0e0e0e0c0c282524242528000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
242424242425282900000000000000272727272727270000000000000000000000000000000000000000000000000000000000000000000000000000373737373737373737360f0e0e0e0c0c1d282524242528000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2424242424242528292900000000002727272727272700000000000000000000000000000000000000000029292929292929292929292929000000003737373737373737370033333333000c1d282524242528000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2424242424242424242529000000002727272727272700000000000000000029290000000000000000292926262626262626262626262626262929003737373737373737370000293329001f1f282524242528000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2524242424242424242529292900000000000027272700000000000000292929292929000000000000292525242424242424242424242424252529003737373737372929292929292929290606282524242528000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2624242424242424242425262629000000000000000000000000002929292929292929290000000029252524242424242424242424242424242525000000000000292626262626262626260707262624242528000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2925242424242424242425242426292929000000000000292929292926262626262626292929292929252424242424242424242424242424242425000000000029292524242424242424240707242424242528000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2929262626262424242424242424252626292900292929292626262626262626262626262626262626252424242424242424242424242424242425290000002929292524242426262626260707262626242628000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0029292929292524242424242424242424262629262626262626262626262626262626262626262626242424242424242424242424242424242425292929292929292524242426282828280606282626262628000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000029292929292624242426242424242424242624242424242424242424242424242424242424242424242424242424242424242424242424242526262626262626252424262629003c3c1f1f282828282828000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000292929262426242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242626290000000c1d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3c3c3c0000000029292629262424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242426292900001d0c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000002900292626262626262424242424242424242424242424242424242424242424242400000000000000000000000000000024242424242424242424242426292900001d0c003c3c3c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000003c3c3c00003939392929292929262626262626262626242424242424242424242424242424242400242424030324242424242424240024242424242424242424242426292900001d0d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
004000001f7501b7501c7501e7501f7501b7501c7501e7501f750177501775017750167501675016750070500c0500c0500c050050500d0500d0500d0500e0500e0500f0500f0501005011050120500005000050
