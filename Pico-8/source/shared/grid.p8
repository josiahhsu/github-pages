pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
// create a grid object with
// boundary checks and other
// useful helper functions

// bx,by = x/y boundaries
// enforce = whether boundaries
//  are enforced
// fn = function for 
//  initializing grid cells
function create_grid(bx,by,
                     enforce,
                     fn)
	local g = {}
	
	// make grid using supplied
	// function to make cells
	g.grid = {}
	for i=1,bx do
		g.grid[i] = {}
		for j=1,by do
			g.grid[i][j] = fn(i,j)
		end
	end
	
	// boundary functions
	function g.in_bounds_x(x)
		return in_range(1,bx,x)
	end
	
	function g.in_bounds_y(y)
		return in_range(1,by,y)
	end
	
	// getters/setters
	// todo: boundary check?
	function g.get(x,y)
		return g.grid[x][y]
	end
	
	function g.set(x,y,cell)
		g.grid[x][y] = cell
	end
	
	function g.swap(x1,y1,x2,y2)
		g.grid[x1][y1],
		g.grid[x2][y2] =
		g.get_cell(x2,y2),
		g.get_cell(x1,y1)
	end
	
	// helpers for operating on
	// collections of cells
	function g.do_cell(x,y,fn)
		if not enforce or
		   (g.in_bounds_x(x) and
		    g.in_bounds_y(y)) then
			fn(x,y)
		end
	end
	
	function g.do_area(x1,x2,y1,y2
	                   ,fn)
		for i=x1,x2 do
			for j=y1,y2 do
				g.do_cell(i,j,fn)
			end
		end
	end
	
	function g.do_lane(l,isrow,fn)
		if isrow then
			g.do_area(1,bx,l,l,fn)
		else
			g.do_area(l,l,1,by,fn)
		end
	end
	
	function g.do_adj(x,y,fn)
		g.do_area(x-1,x+1,y-1,y+1,fn)
	end
	
	function g.do_all(fn)
		g.do_area(1,bx,1,by,fn)
	end
	
	return g
end

-->8
// other helpers
function in_range(s,e,v)
	return s <= v and v <= e
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
