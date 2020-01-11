pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
function _init()
	plr_x = 133
	plr_y = 75

--sprite animations init
	ani_water=1
	ani_plr=64
--adjust colors to new pallete
	poke(0x5f2e, 1)
	for i in all({1,2,3,4,5,6,12,14}) do
		pal(i, 128+i, 1)
	end
	
	wall_id = 1
end

function _update()
--camera controls
	plr_dx = 0
	plr_dy = 0
	if btn(0) and not(plr_col(-1, 0) or plr_col(-1, 4) or plr_col(-1,7)) then
		plr_x -= 1
	end
	if btn(1) and not(plr_col(8, 0) or plr_col(8, 4) or plr_col(8,7)) then
		plr_x += 1
	end
	if btn(2) and not(plr_col(0, -1) or plr_col(4, -1) or plr_col(7,-1)) then 
		plr_y -= 1
	end
	if btn(3) and not(plr_col(0, 8) or plr_col(4, 8) or plr_col(7,8)) then
		plr_y += 1
	end
	camera(plr_x-63, plr_y-63)
--sprite animations
	ani_water+=0.0625
	if ani_water > 2.9 then
			ani_water=1
	end
	ani_plr+=0.0625
	if ani_plr > 66.9 then
			ani_plr=64
	end
end

function _draw()
	cls()	
	map(0, 0, 0, 0, 128, 128)
	spr(ani_plr, plr_x, plr_y)	
end
-->8

function plr_col(x, y)
	return (fget(mget((plr_x+x)/8, (plr_y+y)/8), wall_id))
end
__gfx__
880000882222222200000000000000000005040055555655556566ee555555550005050000000000000050555055555066666666666767666666666600006066
8880008822222222000000000000000000054000e565565555555555555555555000050005550005555555555055505066666666766667666777666766666666
088808802222222200000000000000000005000065555e5556e65655555555555050050000000000050055505055505066666666767667666666666606006660
00088880222222220000000000000000003500006565565555555555555555555050000000005550555555555050505566666666767666666666777666666666
008880002222222200000000000000000004000055e5555555656e65555555550050500000000000500050055050555566666666667676666666666660006006
088088802222222200000000000000000004000055e5555655555555555555550050005055505000555555555550505566666666667666767776766666666666
8880088822222222000000000000000000054000556565566e566565555555550000005000000000505000005050555566666666666666766666666660600000
88000088222222220000000000000000000550005555555e55555555555555555000505000005555555555555550555066666666766676766666777766666666
00000000000000000000000000000000000500004445454444444444444444440004040000000000446466ee4444464400000000666f6f666666666660666660
0000000000000000000000000000000000050500544445444555444544444444400004000444000444444444e464464400000000f6666f666fff666f60666060
0000000000000000000000000000000005040500545445444444444444444444404004000000000046e6464464444e4400000000f6f66f666666666660666060
00000000000000000000000000000000005400005454444444445554444444444040000000004440444444446464464400000000f6f666666666fff660606066
0000000000000000000000000000000000040000445454444444444444444444004040000000000044646e6444e444440000000066f6f6666666666660606666
000000000000000000000000000000000005400044544454555454444444444400400040444040004444444444e444460000000066f666f6fff6f66666606066
000000000000000000000000000000000035400044444454444444444444444400000040000000006e4664644464644600000000666666f66666666660606666
00000000000000000000000000000000303545305444545444445555444444444000404000004444444444444444444e00000000f666f6f66666ffff66606660
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
77777777707070777070000000007770777777771313313333333333333333333030000000003330333333333030303300000000000000000000000000000000
70007007707077770070700000000000777777773313333333131113333333330030300000000000300030033030333300000000000000000000000000000000
77777777777070770070007077707000777777773313333133333333333333330030003033303000333333333330303300000000000000000000000000000000
70700000707077770000007000000000777777773313133111311313333333330000003000000000303000003030333300000000000000000000000000000000
77777777777077707000707000007777777777773333333133333333333333333000303000003333333333333330333000000000000000000000000000000000
06f6f6f0000000000000000000000666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0666556000666600000006660006f6ff000066600000000000000000000777000000000000000000000000000000000000000000000000000000000000000000
0668850006f6f6f00006f6ff00668556006f6ff00000000000000000077777700000000000000000000000000000000000000000000000000000000000000000
06888000066855600066855600688850066855600000000000000000008888000000000000000000000000000000000000000000000000000000000000000000
66885500068885000068885000655800068885000000000000000000008888000000000000000000000000000000000000000000000000000000000000000000
06999040068550000065580006694980065580000000000007777777777777777000000000000000000000000000000000000000000000000000000000000000
00808040669884000669498000684080669498000000000077777777777777777700000000000000000000000000000000000000000000000000000000000000
00666600060804000068408000000000068408000000000757777777777777757770000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000007588777777777777787077000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000075888877777777777588707700000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000757777887777777771777770777000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000757dd8d888777775587777707777000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000077588dd8d8888777d5588d5d111110000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000007078888888888758d5577777707070000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000788dd8d8888788d7775555117070000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000007887777888878775577777707770000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000007778787777877855577777717770000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000007888888888788888575887807870000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000007877777888787777578557587870000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000788dd8d888788d8d578557587870000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000788dd8d888788d8d578557587870000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000788dd8d888788888578557577870000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000007888888888788d8d577777787770000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000788dd8d888788d8d578577787870000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000007877777888788777578878777870000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000007888888888788888777775757777700000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000007888888888788777777775757777700000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000007777777777777777777711155777700000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000711777777777777777777177777777700000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000007777717777777777777777777777777700000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000007777777777777777777777777777771100000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000007777777777777777777777777771777700000000000000000000000000000000000000000000000000000000
0000000000000093a3a3a3a3a3a3a393009292929292626262626242424242424242424242424242424242424242424242424242424242424242424242424242
4242424242426292920000c0c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000093a363737373737363a3930000000092926262626242424242424242424242424242424242424242424242424242424242424242424242424242
4242424242626292000000c0c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000093a373737373737373a3930000000000929292626242424242424242424242424242424242424242424242424242424242424242424242424242
4242424242626292000000c0c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000093a3637373737373737363a39300000000929292926242424242424242424242424242424242424242424242424242424242424242424242424242
4242424242426292000000c0c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000093a3636373737373736363a39300000000000092926242424242424242424242424242424242424242424242424242424242424242424242424242
4242424242426292000000c0c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000093a3637373737373737363a39300000000929292926242424242424242424242424242424242424242424242424242424242424242424242424242
4242424242426292920000c0c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000093a3637373737373737363a39300000000009262424242424242424242424242424242424242424242424242424242424242424242424242424242
4242424242626292929200c0c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000093a353537373735353a3930000000000000092624242424242424242424242424242424242424242424242424242424242424242424242424242
4242424242426292920000c0c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000009282b263535353639200000000000000009292926242424242424242424242424242424242424242424242424242424242424242424242424242
4242424242426292920000c0c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000929282b2b2b253b2b2b282920000000000000000926242424242424242424242424242424242424242424242424242424242424242424242424242
4242424242426292000000c0c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000082a2b2b2b2b272b282829292000000000000009262424242424242424242424242424242424242424242424242424242424242424242424242
4242424242626292000000c0c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000009282a2b2b272727272a292920000000000929262624242424242424242424242424242424242424242424242424242424242424242424242
4242426262629292000000c0c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000009282b272727272a292929200009200926262626242424242424242424242424242424242424242424242424242424242424242626262
6262626262929292000000c0c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000929282a2a2a2b2727282000000000000009262626262626242424242424242424242424242424242424242424242424242626262626292
6292929292929200000000c0c0000000000000000000005464748400000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000929282b2b27282820000000000929262626262626262626262424242424242424242424242424242424242424242629292929292
9200000000009200000000c0c0c00000000000000000005565758500000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000054647484b2b2b282820000000000000092929292929292929292629262424242424242424242424242424242424262629200000000
9200000000000000000000c0c0c00000000000000000005666768600000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000055657585f1f1b282000000000000000000009200929262626262626262626242424242424242424242424242426262929200000000
000000000000000000000000d1e1e1e1e1e1e1e1e1e1e15767778700000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000009256667686c0c0b282647484000000000000000000009292929292929292926242424242424242424242424242626262926060606060
606060606060606060600000d1d10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000054647484009257677787c0f1b255657585000000000000000000000092929200000000926242424242424242424242426262626292927070707070
707050707070707070700000d1d10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000009255657585231343431323c0c0f156667686000000000000000000000000000000000092926262626262626262626262626262629292927070707070
707050707070707070700000d1d10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000929256667686f1e0e0e0e0e0c0c0d057677787033300000000000000000000000000000000929292929292929292929292929292929292007070707070
707050707070707070700000d1d1a0606060606060606060606060a0909000000000000000000000000000000000000000000000000000000000000000000000
000092a2a257677787d0c0c0e0c0c0c0c0c0c0c0e0e0030333330000000000000000000000000000000000009292929292929292000000000000007070707070
707050707070707070700000d1d1a0707070707050707070707050a0909090000000000000000000000000000000000000000000000000000000000000000000
0092a20343434343d0d0d0c0c0c0c0c0c0c0c0c0c0e0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0000000000000000000009200920000000000000000007070707070
707050707070707070700000d1d1a0707070707050707070707050a0909090000000000000000000000000000000000000000000000000000000000000000000
003303434372a254647484c0c0c0f1f1c0e0e0e0e0e0e0e0c0c0c0c0c0c0c0c0c0c0c0c0c0000000000000000000000000000000000000000000007070707070
707050707070707070700000d1d1a0707070707050707070707050a0909000000000000000000000000000000000000000000000000000000000000000000000
0092a24343729255657585c0c0f1546474843303e0e003333300000000000000c0c0c0c0c0000000000000000000000000000000000000000000007070707070
707050707070707070700000d1d1a0707070707050707070707050a0900000000000000000000000000000000000000000000000000000000000000000000000
333303434343a256667686c0c0c0556575850033333333330000000000000000c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c00000000000006060606060
60606060606060606060647484d1a0707070707050707070707050a0900000900000000000000000000000000000000000000000000000000000000000000000
0000330343434357677787d0c0c056667686000000333300000000000000000000000000c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c00000000000000000000000
00000000000000000055657585d1a0606060606050606060606050a0900000000000000000000000000000000000000000000000000000000000000000000000
0092a233434343434343a2a2f1a257677787330000000000000000000000000000000000000000000000000000000000c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0
c0c0c0c0c0c0c0c0c056667686d1a0707070707050707070707050a0909000000000000000000000000000000000000000000000000000000000000000000000
0092723303434343434343434343434343430333000000000000000000000000000000000000000000000000000000000000c0c0c0c0c0c0c0c0c0c0c0c0c0c0
c0c0c0c0c0c0c0c0c057677787d1a0707070707050707070707050a0909000000000000000000000000000000000000000000000000000000000000000000000
9292a27233334343434303a2a2434343434343033300000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000090a0707070707050707070707050a0909090000000000000000000000000000000000000000000000000000000000000000000
0092a2a272727233033392929292720303a292920000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000009090a0707070707050707070707050a0909000000000000000000000000000000000000000000000000000000000000000000000
000092929292929292a27272727272a2a2a292000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000909090a0707070707050707070707050a0900000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
2524242424242425283939000039000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000282828252525252424242424242424242424242424242424242424242424242424252525282828280000000000000000000000000000000000000000000000000000000000
2424242424242528290000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002828282525252424242424242424242424242424242424242424242424242424252525282828000000000000000000000000000000000000000000000000000000000000
2424242424252528121100000000000000000000000000000000000000000027270000000027272727272727272727272727272727000000000000000028282825252424242424242424242424242424242424242424242424242424252525282800000000000000000000000000000000000000000000000000000000000000
2524242424252528120000000000000000000000000000000000000000000027272727272727272727272727272727272727272727000000000000000000282825252424242424242424242424242424242424242424242424242424252525282800000000000000000000000000000000000000000000000000000000000000
2524242424242528290000000000000000000000000000000000000000000027272727272727272727272727272700000000272727000000000000000000002828252424242424242424242424242424242424242424242424242424252525282800000000000000000000000000000000000000000000000000000000000000
2525242424242425280000000000000000000000000000000000000000000027272727272727272727000000000000000000272727000000000000002727272728252424242424242424242424242424242424242424242424242424252528280000000000000000000000000000000000000000000000000000000000000000
2525252424242425280000000000093333333309000000000000000000002727272727272727272727000000002727272727272727000000272727272727272728252424242424242424242424242424242424242424242424242424252528000000000000000000000000000000000000000000000000000000000000000000
2525242424242425280000000009333130303133090000000000000000002727272727272727272727000000002727272727272727000000272727000000002b28252424242424242424242424242424242424242424242424242424252828000000000000000000000000000000000000000000000000000000000000000000
2524242424242525280000000909333034343033090900000000000000002727272727272727272727000000272727272727272727000000272727000000002b28252424242424242424242624242424242424242424242424242424252800000000000000000000000000000000000000000000000000000000000000000000
2424242424252525280000000033333434343433332727272727272727272727272727272727272727000000272727000000000000000000272727272727272b28252424242424242424262626242424242424242424242424242426252800000000000000000000000000000000000000000000000000000000000000000000
242424242425252528000000003333343434343333272727272727272727272727272727272727272700000027270000000000000000000027272727272727272b252624242424242426262626262424242424242424242424242626252800000000000000000000000000000000000000000000000000000000000000000000
242424242424252528000000000909333434330909000000000000000000272727272727272727272700000027270000000000000000000027270000000000002b282626262424242626262626262424242424242424242424262626282800000000000000000000000000000000000000000000000000000000000000000000
2524242424242425280000000009090931310909090000000000000000002727272727272727272700000000272700000000000000000027272700000000000027282828282424242426282828252424242626262626262626262628280000000000000000000000000000000000000000000000000000000000000000000000
2524242424242525280000000000000031310000000000000000000000000027272727272727272700000000272700000000000000000027270000000000000027000028282624242424262828252424242528282828282828282828000000000000000000000000000000000000000000000000000000000000000000000000
2524242424242528290000000000000031310000000000000000000000000027272727272727272700000000272727272727000000000027272700000000000027000000282826242424242428252424242528000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2424242424242528000000000000000027270000000000000000000000000027272727272727272700000000272727272727000000000027272700000037373737373700002828262424242424242424242528000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2424242424252829000000000000000027270000000000000000000000000027272727272727272700000000272727272727000000000027272700003737373737373737370028282626242424242424242528000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2424242424252800000000000000000027270000000000000000000000000027272727272727270000000000272727272727272727272727272700003737373737373737370000002828262626262624242528000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
242424242425280000000000000000002727272727270000000000000000002727272727000027000000000000000027272727272727272727000000373737373737373737360f0c0c0c0c0c0c282524242528000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
242424242425282900000000000000272727272727270000000000000000000000000000000000000000000000000000000000000000000000000000373737373737373737360f0c0c0c0c0c0c282524242528000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2424242424242528292900000000002727272727272700000000000000000000000000000000000000000029292929292929292929292929000000003737373737373737370000000000000c0c282524242528000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2424242424242424242529000000002727272727272700000000000000000029290000000000000000292926262626262626262626262626262929003737373737373737370000292929001f1f282524242528000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2524242424242424242529292900000000000027272700000000000000292929292929000000000000292525242424242424242424242424252529003737373737372929292929292929290606282524242528000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2624242424242424242425262629000000000000000000000000002929292929292929290000000029252524242424242424242424242424242525000000000000292626262626262626260707262624242528000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2925242424242424242425242426292929000000000000292929292926262626262626292929292929252424242424242424242424242424242425000000000029292524242424242424240707242424242528000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2929262626262424242424242424252626292900292929292626262626262626262626262626262626252424242424242424242424242424242425290000002929292524242426262626260707262626242628000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0029292929292524242424242424242424262629262626262626262626262626262626262626262626242424242424242424242424242424242425292929292929292524242426282828280606282626262628000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000292929292926242424262424242424242426242424242424242424242424242424242424242424242424242424242424242424242424242425262626262626262524242626290000001f1f282828282828000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000292929262426242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242626290000000c0c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000029292629262424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242426292900000c0c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000002900292626262626262424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242426292900000c0c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000003939392929292929262626262626262626242424242424242424242424242424242424242424242424242424242424242424242424242424242424242426292900000c0c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
