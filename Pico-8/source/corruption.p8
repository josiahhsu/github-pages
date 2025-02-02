pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
function _init()
	cls()
	
	state = title_state()
end

function _update()
	controls()
	state.update()
end

function _draw()
	state.draw()
end

function template_state()
	local t = {}
	function t:left() end
	function t:right() end
	function t:up() end
	function t:down() end
	function t:o() end
	function t:x() end
	function t:update() end
	function t:draw() end
	return t
end

function controls()
	if btnp(⬅️) then
		state.left()
	end
	if btnp(➡️) then
		state.right()
	end
	if btnp(⬆️) then
		state.up()
	end
	if btnp(⬇️) then
		state.down()
	end

	if btnp(🅾️) then
		state.o()
	end
	if btnp(❎) then
		state.x()
	end
end

// corrupts the game state.
// defaults to corrupting once.
function corrupt(n)
	n = n or 1
	
	for i=1,n do
		poke(abs(rnd(-1)),rnd(-1))
	end
end
-->8
// main menu
function title_state()
	local s=template_state()
	s.time = 0
	s.mirror = false
	
	function s.update()
		s.time+=1
		if s.time % 36 == 0 then
			s.time = 0
			s.mirror=not s.mirror
		end
	end
	
	function s.draw()
		map(0,0)
		local txt = {
		"❎ to start",
		"🅾️ for help"
		}
		for i=1, #txt do
			print(txt[i],42,72+8*i, 7)
		end
		spr(32,64,56,1,1,s.mirror)
	end
	
	function s:x()
		state = map_state()
		cls()
	end
	
	music(0)
	return s
end
-->8
// map
function map_state()
	local s=template_state()
	s.can_roll = true
	s.roll_count=0
	s.roll_result=roll()
	
	function s:update()
		if s.roll_count > 0 then
			s.roll_result=roll()
			s.roll_count-=1
		end
	end
	
	function s:draw()
		map(16,0)
		local res = 2*s.roll_result
		spr(36+res,16,96,2,2)
	end
	
	function s:o()
		if s.can_roll then
			s.roll_count=20
			s.can_roll = false
		end
	end
	
	music(1)
	return s
end

function roll()
	return flr(rnd(6))
end
__gfx__
00000000555555553333333399999999dddddddddddddddddddddddd11111111111111111dddddddddddddd111111111ddddddd11ddddddddddddddddddddddd
00000000566666653bbbbbb398888889d777777dd778877dd777777d1dddddddddddddd11dddddddddddddd1ddddddddddddddd11ddddddddddddddddddddddd
00700700566666653bbbbbb398888889d777777dd778877dd7ee777d1dddddddddddddd11dddddddddddddd1ddddddddddddddd11ddddddddddddddddddddddd
00077000566666653bbbbbb398888889d777777dd778877dd7eeee7d1dddddddddddddd11dddddddddddddd1ddddddddddddddd11ddddddddddddddddddddddd
00077000566666653bbbbbb398888889d777777dd778877dd7eeee7d1dddddddddddddd11dddddddddddddd1ddddddddddddddd11ddddddddddddddddddddddd
00700700566666653bbbbbb398888889d777777dd777777dd7ee777d1dddddddddddddd11dddddddddddddd1ddddddddddddddd11ddddddddddddddddddddddd
00000000566666653bbbbbb398888889d777777dd778877dd777777d1dddddddddddddd11dddddddddddddd1ddddddddddddddd11ddddddddddddddddddddddd
00000000555555553333333399999999dddddddddddddddddddddddd1dddddddddddddd11111111111111111ddddddddddddddd11ddddddd11111111dddddddd
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00cccc00000000000000000000000000555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
0ccc77c0000000000000000000000000577777777777777557777777777777755777777777777775577777777777777557777777777777755777777777777775
0cccc7c0000000000000000000000000577777777777777557777777777777755777777777777775577777777777777557777777777777755777777777777775
0cccccc0000000000000000000000000577777777777777557755777777777755775577777777775577557777775577557755777777557755775577777755775
00cccc00000000000000000000000000577777777777777557755777777777755775577777777775577557777775577557755777777557755775577777755775
00cccc00000000000000000000000000577777777777777557777777777777755777777777777775577777777777777557777777777777755777777777777775
0cccccc0000000000000000000000000577777777777777557777777777777755777777777777775577777777777777557777777777777755777777777777775
cccccccc000000000000000000000000577777755777777557777777777777755777777557777775577777777777777557777775577777755775577777755775
00000000000000000000000000000000577777755777777557777777777777755777777557777775577777777777777557777775577777755775577777755775
00000000000000000000000000000000577777777777777557777777777777755777777777777775577777777777777557777777777777755777777777777775
00000000000000000000000000000000577777777777777557777777777777755777777777777775577777777777777557777777777777755777777777777775
00000000000000000000000000000000577777777777777557777777777557755777777777755775577557777775577557755777777557755775577777755775
00000000000000000000000000000000577777777777777557777777777557755777777777755775577557777775577557755777777557755775577777755775
00000000000000000000000000000000577777777777777557777777777777755777777777777775577777777777777557777777777777755777777777777775
00000000000000000000000000000000577777777777777557777777777777755777777777777775577777777777777557777777777777755777777777777775
00000000000000000000000000000000555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00777700007777000077770007777700077777700777777000777700070000700777777007777770070000700700000007000070070000700077770000777700
07000070070000700700007007000070070000000700000007000000070000700000700000007000070007000700000007700770077000700700007007000070
07000070070000700700000007000070070000000700000007000000070000700000700000007000070070000700000007077070070700700700007007000070
07777770077777000700000007000070077770000777700007000000077777700000700000007000077700000700000007000070070070700700007007777700
07000070070000700700000007000070070000000700000007000770070000700000700000007000070070000700000007000070070007700700007007000000
07000070070000700700007007000070070000000700000007000070070000700000700007007000070007000700000007000070070000700700007007000000
07000070007777000077770007777700077777700700000000777700070000700777777007777000070000700777777007000070070000700077770007000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00777700077777000777777007777770070000700700007007000070070000700700007007777770000000000000000000000000000000000000000000000000
07000070070000700700000000007000070000700700007007000070007007000070070000000070000000000000000000000000000000000000000000000000
07000070070000700700000000007000070000700700007007000070000770000007700000000700000000000000000000000000000000000000000000000000
07000070077777000777777000007000070000700700007007000070000770000000700000007000000000000000000000000000000000000000000000000000
07007070070070000000007000007000070000700700007007077070000770000000700000070000000000000000000000000000000000000000000000000000
07000700070007000000007000007000070000700070070007700770007007000000700000700000000000000000000000000000000000000000000000000000
00777070070000700777777000007000007777000007700007000070070000700000700007777770000000000000000000000000000000000000000000000000
__label__
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
56666665566666655666666556666665566666655666666556666665566666655666666556666665566666655666666556666665566666655666666556666665
56666665566666655666666556666665566666655666666556666665566666655666666556666665566666655666666556666665566666655666666556666665
56666665566666655666666556666665566666655666666556666665566666655666666556666665566666655666666556666665566666655666666556666665
56666665566666655666666556666665566666655666666556666665566666655666666556666665566666655666666556666665566666655666666556666665
56666665566666655666666556666665566666655666666556666665566666655666666556666665566666655666666556666665566666655666666556666665
56666665566666655666666556666665566666655666666556666665566666655666666556666665566666655666666556666665566666655666666556666665
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055555555
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
55555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055555555
55555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055555555
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
55555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055555555
55555555000000005555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555550000000055555555
56666665000000005666666556666665566666655666666556666665566666655666666556666665566666655666666556666665566666650000000056666665
56666665000000005666666556666665566666655666666556666665566666655666666556666665566666655666666556666665566666650000000056666665
56666665000000005666666556666665566666655666666556666665566666655666666556666665566666655666666556666665566666650000000056666665
56666665000000005666666556666665566666655666666556666665566666655666666556666665566666655666666556666665566666650000000056666665
56666665000000005666666556666665566666655666666556666665566666655666666556666665566666655666666556666665566666650000000056666665
56666665000000005666666556666665566666655666666556666665566666655666666556666665566666655666666556666665566666650000000056666665
55555555000000005555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555550000000055555555
55555555000000005555555500000000000000000000000000000000000000000000000000000000000000000000000000000000555555550000000055555555
56666665000000005666666500777700007777000777770007777700070000700077770007777770077777700077770007000070566666650000000056666665
56666665000000005666666507000070070000700700007007000070070000700700007000007000000070000700007007700070566666650000000056666665
56666665000000005666666507000000070000700700007007000070070000700700007000007000000070000700007007070070566666650000000056666665
56666665000000005666666507000000070000700777770007777700070000700777770000007000000070000700007007007070566666650000000056666665
56666665000000005666666507000000070000700700700007007000070000700700000000007000000070000700007007000770566666650000000056666665
56666665000000005666666507000070070000700700070007000700070000700700000000007000000070000700007007000070566666650000000056666665
55555555000000005555555500777700007777000700007007000070007777000700000000007000077777700077770007000070555555550000000055555555
55555555000000005555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555550000000055555555
56666665000000005666666556666665566666655666666556666665566666655666666556666665566666655666666556666665566666650000000056666665
56666665000000005666666556666665566666655666666556666665566666655666666556666665566666655666666556666665566666650000000056666665
56666665000000005666666556666665566666655666666556666665566666655666666556666665566666655666666556666665566666650000000056666665
56666665000000005666666556666665566666655666666556666665566666655666666556666665566666655666666556666665566666650000000056666665
56666665000000005666666556666665566666655666666556666665566666655666666556666665566666655666666556666665566666650000000056666665
56666665000000005666666556666665566666655666666556666665566666655666666556666665566666655666666556666665566666650000000056666665
55555555000000005555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555550000000055555555
55555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055555555
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
55555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055555555
555555550000000000000000000000000000000000000000000000000000000000cccc0000000000000000000000000000000000000000000000000055555555
56666665000000000000000000000000000000000000000000000000000000000ccc77c000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000cccc7c000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000cccccc000000000000000000000000000000000000000000000000056666665
566666650000000000000000000000000000000000000000000000000000000000cccc0000000000000000000000000000000000000000000000000056666665
566666650000000000000000000000000000000000000000000000000000000000cccc0000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000cccccc000000000000000000000000000000000000000000000000056666665
5555555500000000000000000000000000000000000000000000000000000000cccccccc00000000000000000000000000000000000000000000000055555555
55555555000000000000000000000000000000005555555555555555555555555555555555555555555555550000000000000000000000000000000055555555
56666665000000000000000000000000000000005666666556666665566666655666666556666665566666650000000000000000000000000000000056666665
56666665000000000000000000000000000000005666666556666665566666655666666556666665566666650000000000000000000000000000000056666665
56666665000000000000000000000000000000005666666556666665566666655666666556666665566666650000000000000000000000000000000056666665
56666665000000000000000000000000000000005666666556666665566666655666666556666665566666650000000000000000000000000000000056666665
56666665000000000000000000000000000000005666666556666665566666655666666556666665566666650000000000000000000000000000000056666665
56666665000000000000000000000000000000005666666556666665566666655666666556666665566666650000000000000000000000000000000056666665
55555555000000000000000000000000000000005555555555555555555555555555555555555555555555550000000000000000000000000000000055555555
55555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055555555
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
55555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055555555
55555555000000000000000000000000000000000007777700000077700770000007707770777077707770000000000000000000000000000000000055555555
56666665000000000000000000000000000000000077070770000007007070000070000700707070700700000000000000000000000000000000000056666665
56666665000000000000000000000000000000000077707770000007007070000077700700777077000700000000000000000000000000000000000056666665
56666665000000000000000000000000000000000077070770000007007070000000700700707070700700000000000000000000000000000000000056666665
56666665000000000000000000000000000000000007777700000007007700000077000700707070700700000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
55555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055555555
55555555000000000000000000000000000000000007777700000077700770777000007070777070007770000000000000000000000000000000000055555555
56666665000000000000000000000000000000000077000770000070007070707000007070700070007070000000000000000000000000000000000056666665
56666665000000000000000000000000000000000077070770000077007070770000007770770070007770000000000000000000000000000000000056666665
56666665000000000000000000000000000000000077000770000070007070707000007070700070007000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000007777700000070007700707000007070777077707000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
55555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055555555
55555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055555555
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
55555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055555555
55555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055555555
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
55555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055555555
55555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055555555
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
56666665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000056666665
55555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
56666665566666655666666556666665566666655666666556666665566666655666666556666665566666655666666556666665566666655666666556666665
56666665566666655666666556666665566666655666666556666665566666655666666556666665566666655666666556666665566666655666666556666665
56666665566666655666666556666665566666655666666556666665566666655666666556666665566666655666666556666665566666655666666556666665
56666665566666655666666556666665566666655666666556666665566666655666666556666665566666655666666556666665566666655666666556666665
56666665566666655666666556666665566666655666666556666665566666655666666556666665566666655666666556666665566666655666666556666665
56666665566666655666666556666665566666655666666556666665566666655666666556666665566666655666666556666665566666655666666556666665
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555

__gff__
0000000000010200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000101020000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000101040004040400000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100010101010101010101010101000101050505000600000004040504000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010001424e5151544f53484e4d01000101000000000404050405000004000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100010101010101010101010101000101000000000000000000000006000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000101000000000000000000000004000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000101000404040406040400060404000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000010101010101000000000101000500000000000504040005000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000101000600000000000000000004000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000101000404040604000000000004000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000101070b0b080004000000000005000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01000000000000000000000000000001010d0f0f0c0005040405050405000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01000000000000000000000000000001010d0f0f0c0004000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000101090e0e0a0004060404050404040301000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
011200080062500000000000000000655000000000000000000000000000000000000060000000000000000000000000000000000000006000000000000000000000000000000000000000600000000000000000
011200201813218132181321813200605006000060018132131321313213132131320060500000000001313218132181321b13218132181321613216130181321313213132131321313200605000000000013132
01260000181321813218132181001b1321b1321b132000021d1321b1321b1001f1321f1321f1321f13218100181321813218102181321b1321b13203002181321d1321b1321b1001813218132181321813200000
012600040062500615006550062500600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
03 01004344
03 02034344

