pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
// defines boundaries to check.
// set_bounds must be called.

_grid,_bx,_by,_enforce =
 nil,nil,nil,nil

function set_grid(grid,enforce)
	_grid,_bx,_by,_enforce =
	 grid, #grid, #grid[1],enforce
end

function get_cell(x,y)
	return _grid[x][y]
end

function in_range(s,e,v)
	return s <= v and v <= e
end

function in_bounds_x(x)
	return not _enforce or
	       in_range(1,_bx,x)
end

function in_bounds_y(y)
	return not _enforce or
	       in_range(1,_by,y)
end
-->8
// wrappers for cell functions.
// only perform function if
// position is in bounds.
function cell_do(x,y,f)
	if in_bounds_x(x) and
	   in_bounds_y(y) then
		f(x,y)
	end
end

function cell_do_area(x1,x2,
                      y1,y2,f)
	for i=x1,x2 do
		for j=y1,y2 do
			cell_do(i,j,f)
		end
	end
end

function cell_do_lane(l,isrow,f)
	if isrow then
		cell_do_area(1,_bx,l,l,f)
	else
		cell_do_area(l,l,1,_bx,f)
	end
end

function cell_do_adj(x,y,f)
	cell_do_area(x-1,x+1,y-1,y+1,f)
end

function cell_do_all(f)
	cell_do_area(1,_bx,1,_by,f)
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
