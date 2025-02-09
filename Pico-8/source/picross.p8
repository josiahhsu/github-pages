pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
#include shared/grid.p8
#include shared/state.p8
#include shared/math.p8:0

function _init()
	cls()
	total = 0
	n = 10
	grid = make_grid()
	px,py = 1,1
	mistakes = 0
	
	state = game_state()
end

function _update()
	state.controls()
end

function _draw()
	draw_grid()
	state.draw()
end
-->8
function make_grid()
	//makes grid of cells
	total = 0
	local function make_cell()
		//makes a cell and determines
		//whether it's marked or not
		local cell = {}
		cell.value = round(rnd(1))
		total+=cell.value
		cell.revealed = false
		cell.mistake = false
		return cell
	end
	
	local grid=create_grid(n,n,
	                       true,
	                       make_cell)
	
	// make sure grid has good
	// amount of cells
	if total < 40 or total > 60 then
		grid = make_grid()
	end
	return grid
end
-->8
function game_state()
	local s = template_state()
	
	s.set_btnp(⬅️,move_horz,-1)
	s.set_btnp(➡️,move_horz,1)
	s.set_btnp(⬆️,move_vert,-1)
	s.set_btnp(⬇️,move_vert,1)
	s.set_btn(🅾️,reveal_cell,1)
	s.set_btn(❎,reveal_cell,0)
	
	function s.draw()
		draw_pointer(px,py)
		print("⬆️",14,4,5)
		print("⬅️⬇️➡️",6,10,5)
		print("to move",4,16,5)
		print("🅾️ to color",4,22,5)
		print("❎ to clear",4,28,5)
		print("remaining:"..total,4,34,5)
	end
	
	return s
end

function end_state()
	local s = template_state()
	
	function s.draw()
		msg = mistakes==0 and 
		     "perfect!" or "finished!"
		print(msg,4,10,5)
		print("🅾️ and ❎",4,22,5)
		print("to restart",4,28,5)
	end
	
	return s
end

function move_horz(dx)
	if grid.in_bounds_x(px+dx) then
		px += dx
	end
end

function move_vert(dy)
	if grid.in_bounds_y(py+dy) then
		py += dy
	end
end

function reveal_cell(value)
	//opens a cell, either marking
	//or clearing based on value
	local cell = grid.get(px,py)
	if not cell.revealed then
		cell.revealed = true
		if cell.value != value then
			cell.mistake = true
			mistakes += 1
		end
		if cell.value == 1 then
			total -= 1
			if total == 0 then
				grid.do_all(
				function(x,y)
					grid.get(x,y).revealed=true
				end
				)
				state=end_state()
			end
		end
	end
end
-->8
function coords(p)
	//translates value to partial
	//position on grid
	return 7*p + 48
end

function draw_cell(x,y)
	//draws cells on grid
	local cell = grid.get(x,y)
	x,y = coords(x),coords(y)
	//dictates how cell is drawn
	if cell.revealed then
		local c = 1 + cell.value * 10
		rectfill(x,y,x+4,y+4,c)
		if cell.mistake then
			circfill(x+2,y+2,0,8)
		end
	end
	rect(x,y,x+4,y+4,5)
end

function draw_grid()
	//draws grid and info text
	rectfill(0,0,128,128,7)
	rect(0,0,52,52,5)
	rect(52,52,128,128,5)
	print("mistakes:"..mistakes,4,40,5)
	draw_nums()
	grid.do_all(draw_cell)
end

function draw_pointer(x,y)
	//draws pointer position
	x,y = coords(x),coords(y)
	rect(0,y-1,128,y+5,6)
	rect(x-1,0,x+5,128,6)
	rect(x,y,x+4,y+4,9)
end

function draw_nums()
	for i = 1, n do
		local row = count_nums(i,true)
		for j = 1, #row do
			print(row[j],49-j*7,48+i*7,5)
		end
		
		local col = count_nums(i,false)
		for j = 1, #col do
			print(col[j],49+7*i,53-j*7,5)
		end
	end
end
-->8
function count_nums(l,isrow)
	local cnt,nums = 0,{}
	
	local function addnz(v)
		if cnt > 0 then
			add(nums,cnt,1)
			cnt = 0
		end
	end
	
	grid.do_lane(l,isrow,
	function(x,y)
		local v = grid.get(x,y).value
		cnt += v
		if v == 0 then
			addnz(v)
		end
	end)
	
	addnz(v)
	return nums
end
__label__
55555555555555555555555555555555555555555555555555555766666667777777777777777777777777777777777777777777777777777777777777777777
57777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
57777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
57777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
57777777777777755555777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
57777777777777555755577777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
57777777777777557775577777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
57777777777777557775577777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
57777777777777755555777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
57777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
57777775555577755555777555557777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
57777755577557557775575577555777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
57777755777557557775575577755777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
57777755577557555755575577555777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
57777775555577755555777555557777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
57777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
57775557755777775557755757575557777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
57777577575777775557575757575777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
57777577575777775757575757575577777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
57777577575777775757575755575777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
57777577557777775757557775775557777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
57777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
57777555557777775557755777775557555755575757777777775767777767777777777777777777777777777777777777777777777777777777777777777777
57775577755777777577575777775557575757575757777777775767777767777777777777777777777777777777777777777777777777777777777777777777
57775575755777777577575777775757555755775577777777775767777767777777777777777777777777777777777777777777777777777777777777777777
57775577755777777577575777775757575757575757777777775767555767777777777777777557777777777777777777557777777777777777777555777777
57777555557777777577557777775757575757575757777777775767775767777777777777777757777777777777777777757777777777777777777775777777
57777777777777777777777777777777777777777777777777775767555767777777777777777757777777777777777777757777777777777777777755777777
57777555557777775557755777777557577755575557555777775767577767777777777777777757777777777777777777757777777777777777777775777777
57775575755777777577575777775777577757775757575777775767555767777777777777777555777777777777777777555777777777777777777555777777
57775557555777777577575777775777577755775557557777775767777767777777777777777777777777777777777777777777777777777777777777777777
57775575755777777577575777775777577757775757575777775767777767777777777777777777777777777777777777777777777777777777777777777777
57777555557777777577557777777557555755575757575777775767557767755577775557777557777755577777777777557777777777777777777555777777
57777777777777777777777777777777777777777777777777775767757767777577777757777757777777577777777777757777777777777777777775777777
57775557555755575557555755775557557775577777555755575767757767755577775557777757777755577777777777757777777777777777777555777777
57775757577755575757757757577577575757777577577757575767757767757777775777777757777757777777777777757777777777777777777577777777
57775577557757575557757757577577575757777777555755575767555767755577775557777555777755577777777777555777777777777777777555777777
57775757577757575757757757577577575757577577775777575767777767777777777777777777777777777777777777777777777777777777777777777777
57775757555757575757555757575557575755577777555777575767777767777777777777777777777777777777777777777777777777777777777777777777
57777777777777777777777777777777777777777777777777775767557767755577775557777557777757577775757777557777755777775577777557777777
57775557555775575557555757575557755777775557777777775767757767777577777757777757777757577775757777757777775777777577777757777777
57775557757757777577575757575777577775775757777777775767757767775577775557777757777755577775557777757777775777777577777757777777
57775757757755577577555755775577555777775757777777775767757767777577775777777757777777577777757777757777775777777577777757777777
57775757757777577577575757575777775775775757777777775767555767755577775557777555777777577777757777555777755577775557777555777777
57775757555755777577575757575557557777775557777777775767777767777777777777777777777777777777777777777777777777777777777777777777
57777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
57777777777777777777777777777777777777777777777777775767557767755577775557777555777755777775757777555777757777775577777557777777
57777777777777777777777777777777777777777777777777775767757767777577777757777775777775777775757777775777757777777577777757777777
57777777777777777777777777777777777777777777777777775767757767755577775557777555777775777775557777555777755577777577777757777777
57777777777777777777777777777777777777777777777777775767757767757777775777777577777775777777757777577777757577777577777757777777
57777777777777777777777777777777777777777777777777775767555767755577775557777555777755577777757777555777755577775557777555777777
57777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
55555555555555555555555555555555555555555555555555555565555565555555555555555555555555555555555555555555555555555555555555555555
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
67777777777777777777755777775557777557777755777777775769999967555557755555775555577555557755555775555577555557755555775555577777
67777777777777777777775777777757777757777775777777775769777967577757757775775777577577757757775775777577577757757775775777577777
67777777777777777777775777775557777757777775777777775769777967577757757775775777577577757757775775777577577757757775775777577777
67777777777777777777775777775777777757777775777777775769777967577757757775775777577577757757775775777577577757757775775777577777
67777777777777777777755577775557777555777755577777775769999967555557755555775555577555557755555775555577555557755555775555577777
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777755577775557777557777755777777775765555567555557755555775555577555557755555775555577555557755555775555577777
77777777777777777777777577777757777757777775777777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777755577775557777757777775777777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777757777775777777757777775777777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777755577775557777555777755577777775765555567555557755555775555577555557755555775555577555557755555775555577777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777755777775557777555777755577777775765555567555557755555775555577555557755555775555577555557755555775555577777
77777777777777777777775777777757777775777777577777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777775777775557777555777755577777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777775777775777777577777757777777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777755577775557777555777755577777775765555567555557755555775555577555557755555775555577555557755555775555577777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777775557777555777755777777775765555567555557755555775555577555557755555775555577555557755555775555577777
77777777777777777777777777777757777775777775777777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777775557777555777775777777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777775777777577777775777777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777775557777555777755577777775765555567555557755555775555577555557755555775555577555557755555775555577777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777555777757777777775765555567555557755555775555577555557755555775555577555557755555775555577777
77777777777777777777777777777777777775777757777777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777777777777555777755577777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777777777777577777757577777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777777777777555777755577777775765555567555557755555775555577555557755555775555577555557755555775555577777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777755577775577777557777755777777775765555567555557755555775555577555557755555775555577555557755555775555577777
77777777777777777777777577777577777757777775777777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777755577777577777757777775777777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777757777777577777757777775777777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777755577775557777555777755577777775765555567555557755555775555577555557755555775555577555557755555775555577777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777575777755777777775765555567555557755555775555577555557755555775555577555557755555775555577777
77777777777777777777777777777777777575777775777777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777777777777555777775777777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777777777777775777775777777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777777777777775777755577777775765555567555557755555775555577555557755555775555577555557755555775555577777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777775577777555777755777777775765555567555557755555775555577555557755555775555577555557755555775555577777
77777777777777777777777777777577777775777775777777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777777577777755777775777777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777777577777775777775777777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777775557777555777755577777775765555567555557755555775555577555557755555775555577555557755555775555577777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777555777755577777775765555567555557755555775555577555557755555775555577555557755555775555577777
77777777777777777777777777777777777775777777577777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777777777777755777775577777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777777777777775777777577777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777777777777555777755577777775765555567555557755555775555577555557755555775555577555557755555775555577777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777577777755777777775765555567555557755555775555577555557755555775555577555557755555775555577777
77777777777777777777777777777777777577777775777777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777777777777555777775777777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777777777777575777775777777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777777777777555777755577777775765555567555557755555775555577555557755555775555577555557755555775555577777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777

