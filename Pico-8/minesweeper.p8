pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
function _init()
 cls()
 
 // grid size
 m = 18
 n = 14
 
 // mines and cells to open
 mines = 40
 remaining = m*n - mines
 
 grid = make_grid()
 
 // player position
 px = 1
 py = 1
 
 t = 0
 state = init_state()
end

function _update()
 state.update()
end

function _draw()
 draw_grid()
 state.draw()
end
-->8
function make_cell(mine)
 //makes a cell and determines
 //whether it's marked or not
 local cell = {}
 cell.spr = 20
 cell.mine = mine
 cell.flagged = false
 cell.revealed = false
 return cell
end

function shuffle(t)
 for i = 1, #t do
  local j = ceil(rnd(i))
  t[i],t[j] = t[j],t[i]
 end
end

function mine_placement()
 local t={}
 for i=1, m*n do
  t[i] = i<=mines
 end
 
 shuffle(t)
 return t
end

function make_grid()
 //makes grid of cells
 local ms = mine_placement()
 local grid = {}
 for i = 1, m do
  grid[i] = {}
  for j = 1, n do
   grid[i][j] = make_cell(deli(ms))
  end
 end
 return grid
end
-->8
function controls()
 //player controls for movement
 //and revealing cells
 if btnp(0) then
  move_horz(-1)
 elseif btnp(1) then
  move_horz(1)
 elseif btnp(2) then
  move_vert(-1)
 elseif btnp(3) then
  move_vert(1)
 end
 
 if btnp(4) then
  state.z()
 elseif btnp(5) then
  cell_do(px,py, flag_cell)
 end
end

function move_horz(dx)
 if in_bounds_x(px+dx) then 
  px += dx
 end
end

function move_vert(dy)
 if in_bounds_y(py+dy) then 
  py += dy 
 end
end

function in_range(s,e,v)
 return s <= v and v <= e
end

function in_bounds_x(x)
 return in_range(1,m,x)
end

function in_bounds_y(y)
 return in_range(1,n,y)
end

function in_bounds(x,y)
 return in_bounds_x(x) and
        in_bounds_y(y)
end

// wrapper for cell functions.
// only perform function if
// position is in bounds.
function cell_do(x,y,f)
 if in_bounds(x,y) then
  f(x,y)
 end
end

function opening_move(x,y)
 // guarantees first open
 // will be a cell w/ no
 // surrounding mines.
 local cnt = 0
 local empty = {}
 for i = 1, m do
  for j = 1, n do
   local cell = grid[i][j]
   if in_range(x-1,x+1,i) and
      in_range(y-1,y+1,j) then
     // remove any mines in
     // immediate area
     if cell.mine then
      cell.mine = false
      cnt+=1
     end
   else
    if not cell.mine then
     // record all other
     // empty cells
     add(empty, {i,j})
    end
   end
  end
 end
 
 // add back mines in 
 // other empty cells
 shuffle(empty)
 for i=1, cnt do
  local x,y = unpack(deli(empty))
  grid[x][y].mine = true
 end
 
 cell_do(x,y,open_cell)
end

function open_cell(x,y) 
 local cell = grid[x][y]
 
 // don't open revealed
 // or flagged cells
 if cell.revealed or
    cell.flagged then
  return
 end 
 
 remaining -= 1
 cell.revealed = true

 if cell.mine then
  end_game(false)
  // mark opened mine
  cell.spr = 19
 else
  // find # of surrounding mines
  local cnt = 0
  local cells = {}
  for i=x-1, x+1 do
   for j=y-1, y+1 do
    add(cells, {i,j})
    if in_bounds(i,j) and
       grid[i][j].mine then
     cnt += 1
    end
   end
  end
  cell.spr=cnt
  
  // open surrounding cells if
  // there's no mines
  if cnt == 0 then
   function f(e)
    cell_do(e[1],e[2],open_cell)
   end
   foreach(cells, f)
  end
 end
 
 if remaining == 0 then
  end_game(true)
 end
end

function flag_cell(x,y) 
 local cell = grid[x][y]
 
 // don't flag revealed cells
 if cell.revealed then
  return
 end
 
 // toggle flag
 local f = cell.flagged
 cell.spr = f and 20 or 16
 mines += f and 1 or -1
 cell.flagged = not f
end

function end_game(win)
 // reveal all mine locations
 for i = 1, m do
  for j = 1, n do
   local cell = grid[i][j]
   cell.revealed=true
   if cell.mine and 
      not cell.flagged then
    // flag mines if game won,
    // show mines if game lost
    cell.spr = win and 16 or 18
   elseif cell.flagged and
          not cell.mine then
    // mark incorrect flags
    cell.spr = 17
   end
  end
 end
 
 if win then
  mines = 0
 end
 
 state = end_state()
end
-->8
function coords(x,y)
 //translates value to partial
 //position on grid 
 return (x-1)*7,y*7+18
end

function draw_cell(x,y)  
 //draws cells on grid
 local sx,sy = coords(x,y)
 spr(grid[x][y].spr,sx,sy)
end

function draw_grid()
 //draws grid and info text
 rectfill(0,0,126,128,7)
 print("⬆️",13,4,5)
 print("⬅️⬇️➡️",5,10,5)
 print("to move",3,16,5)
 line(35,0,35,24,5)
 print("🅾️ to open",38,5,5)
 print("❎ to flag",38,16,5)
 line(84,0,84,24,5)
 print("mines:"..mines,87,5,5)
 print("time:"..flr(t), 87,16,5)
 for i = 1, m do
  for j = 1, n do
   cell_do(i,j,draw_cell)
  end
 end
end

function draw_pointer()
 //draws pointer position
 local x,y = coords(px,py)
 rect(x,y,x+7,y+7,9)
end

-->8
function init_state()
 // before start of game
 local s = {}
 
 function s.update()
  controls()
 end
 
 function s.draw()
  draw_pointer()
 end
 
 function s.z()
  state = play_state()
  opening_move(px,py)
 end
 
 return s
end

function play_state()
 // during main gameplay
 local s = {}
 
 function s.update()
  controls()
  t+=1/30
 end
 
 function s.draw()
  draw_pointer()
 end
 
 function s.z()
  cell_do(px,py, open_cell)
 end
 
 return s
end

function end_state()
 // game is over
 local s = {}
 
 function s.update() end
 
 function s.draw() end
 
 function s.z() end
 
 return s
end
__gfx__
55555555555555555555555555555555555555555555555555555555555555555555555500000000000000000000000000000000000000000000000000000000
5dddddd5566cc66556633665566886655616616556eeee655662266556dddd655660066500000000000000000000000000000000000000000000000000000000
5dddddd55666c66556366365568668655616616556e666655626666556666d655606606500000000000000000000000000000000000000000000000000000000
5dddddd55666c66556666365566668655616616556eee6655622266556666d655606606500000000000000000000000000000000000000000000000000000000
5dddddd55666c66556663665566688655611116556666e655626626556666d655660066500000000000000000000000000000000000000000000000000000000
5dddddd55666c66556636665568668655666616556666e655626626556666d655606606500000000000000000000000000000000000000000000000000000000
5dddddd5566ccc6556333365566886655666616556eee6655662266556666d655660066500000000000000000000000000000000000000000000000000000000
55555555555555555555555555555555555555555555555555555555555555555555555500000000000000000000000000000000000000000000000000000000
55555555555555555555555555555555555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5666e6655888e8855661616558818185566666650000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
566ee665588ee8855111116551111185566666650000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
56eee66558eee8855619911558199115566666650000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5eeee6655eeee8855119916551199185566666650000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5666e6655888e8855611111558111115566666650000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5666e6655888e8855616166558181885566666650000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555555555555555555555555555555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
77777777777777777777777777777777777577777777777777777777777777777777777777777777777757777777777777777777777777777777777777777770
77777777777777777777777777777777777577777777777777777777777777777777777777777777777757777777777777777777777777777777777777777770
77777777777777777777777777777777777577777777777777777777777777777777777777777777777757777777777777777777777777777777777777777770
77777777777777777777777777777777777577777777777777777777777777777777777777777777777757777777777777777777777777777777777777777770
77777777777777555557777777777777777577777777777777777777777777777777777777777777777757777777777777777777777777777777777777777770
77777777777775557555777777777777777577755555777777555775577777755755575557557777777757755575557557755577557777755575777777777770
77777777777775577755777777777777777577557775577777757757577777575757575777575777777757755577577575757775777757777575777777777770
77777777777775577755777777777777777577557575577777757757577777575755575577575777777757757577577575755775557777755575557777777770
77777777777777555557777777777777777577557775577777757757577777575757775777575777777757757577577575757777757757757775757777777770
77777777777777777777777777777777777577755555777777757755777777557757775557575777777757757575557575755575577777755575557777777770
77777755555777555557775555577777777577777777777777777777777777777777777777777777777757777777777777777777777777777777777777777770
77777555775575577755755775557777777577777777777777777777777777777777777777777777777757777777777777777777777777777777777777777770
77777557775575577755755777557777777577777777777777777777777777777777777777777777777757777777777777777777777777777777777777777770
77777555775575557555755775557777777577777777777777777777777777777777777777777777777757777777777777777777777777777777777777777770
77777755555777555557775555577777777577777777777777777777777777777777777777777777777757777777777777777777777777777777777777777770
77777777777777777777777777777777777577777777777777777777777777777777777777777777777757777777777777777777777777777777777777777770
77755577557777755577557575755577777577755555777777555775577777555757775557755777777757755575557555755577777555755577777777777770
77775775757777755575757575757777777577557575577777757757577777577757775757577777777757775777577555757777577775757577777777777770
77775775757777757575757575755777777577555755577777757757577777557757775557577777777757775777577575755777777755757577777777777770
77775775757777757575757555757777777577557575577777757757577777577757775757575777777757775777577575757777577775757577777777777770
77775775577777757575577757755577777577755555777777757755777777577755575757555777777757775775557575755577777555755577777777777770
77777777777777777777777777777777777577777777777777777777777777777777777777777777777757777777777777777777777777777777777777777770
77777777777777777777777777777777777577777777777777777777777777777777777777777777777757777777777777777777777777777777777777777770
77777777777777777777777777777777777577777777777777777777777777777777777777777777777757777777777777777777777777777777777777777770
77777777777777777777777777777777777577777777777777777777777777777777777777777777777757777777777777777777777777777777777777777770
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555550
56666665666666566cc665dddddd5dddddd5dddddd566cc665666666566666656666665666666566666656666665666666566666656666665666666566666650
566666656666665666c665dddddd5dddddd5dddddd5666c665666666566666656666665666666566666656666665666666566666656666665666666566666650
566666656666665666c665dddddd5dddddd5dddddd5666c665666666566666656666665666666566666656666665666666566666656666665666666566666650
566666656666665666c665dddddd5dddddd5dddddd5666c665666666566666656666665666666566666656666665666666566666656666665666666566666650
566666656666665666c665dddddd5dddddd5dddddd5666c665666666566666656666665666666566666656666665666666566666656666665666666566666650
56666665666666566ccc65dddddd5dddddd5dddddd566ccc65666666566666656666665666666566666656666665666666566666656666665666666566666650
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555550
56666665666666566cc665dddddd5dddddd5dddddd566cc665666666566666656666665666666566666656666665666666566666656666665666666566666650
566666656666665666c665dddddd5dddddd5dddddd5666c665666666566666656666665666666566666656666665666666566666656666665666666566666650
566666656666665666c665dddddd5dddddd5dddddd5666c665666666566666656666665666666566666656666665666666566666656666665666666566666650
566666656666665666c665dddddd5dddddd5dddddd5666c665666666566666656666665666666566666656666665666666566666656666665666666566666650
566666656666665666c665dddddd5dddddd5dddddd5666c665666666566666656666665666666566666656666665666666566666656666665666666566666650
56666665666666566ccc65dddddd5dddddd5dddddd566ccc65666666566666656666665666666566666656666665666666566666656666665666666566666650
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555550
5666666566666656633665dddddd5dddddd566cc6656633665663366566cc66566cc665668866566666656666665666666566666656666665666666566666650
5666666566666656366365dddddd5dddddd5666c66563663656366365666c665666c665686686566666656666665666666566666656666665666666566666650
5666666566666656666365dddddd5dddddd5666c66566663656666365666c665666c665666686566666656666665666666566666656666665666666566666650
5666666566666656663665dddddd5dddddd5666c66566636656663665666c665666c665666886566666656666665666666566666656666665666666566666650
5666666566666656636665dddddd5dddddd5666c66566366656636665666c665666c665686686566666656666665666666566666656666665666666566666650
5666666566666656333365dddddd5dddddd566ccc656333365633336566ccc6566ccc65668866566666656666665666666566666656666665666666566666650
55555555555555555555599999999555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555550
56666665666e66566cc669dddddd9dddddd566cc665666e66566cc665dddddd5dddddd566cc665666e6656666665666666566666656666665666666566666650
5666666566ee665666c669dddddd9dddddd5666c66566ee665666c665dddddd5dddddd5666c66566ee6656666665666666566666656666665666666566666650
566666656eee665666c669dddddd9dddddd5666c6656eee665666c665dddddd5dddddd5666c6656eee6656666665666666566666656666665666666566666650
56666665eeee665666c669dddddd9dddddd5666c665eeee665666c665dddddd5dddddd5666c665eeee6656666665666666566666656666665666666566666650
56666665666e665666c669dddddd9dddddd5666c665666e665666c665dddddd5dddddd5666c665666e6656666665666666566666656666665666666566666650
56666665666e66566ccc69dddddd9dddddd566ccc65666e66566ccc65dddddd5dddddd566ccc65666e6656666665666666566666656666665666666566666650
55555555555555555555599999999555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555550
5666666566cc665663366566cc66566cc66566cc66566cc66566cc665dddddd5dddddd566cc66566cc6656666665666666566666656666665666666566666650
56666665666c6656366365666c665666c665666c665666c665666c665dddddd5dddddd5666c665666c6656666665666666566666656666665666666566666650
56666665666c6656666365666c665666c665666c665666c665666c665dddddd5dddddd5666c665666c6656666665666666566666656666665666666566666650
56666665666c6656663665666c665666c665666c665666c665666c665dddddd5dddddd5666c665666c6656666665666666566666656666665666666566666650
56666665666c6656636665666c665666c665666c665666c665666c665dddddd5dddddd5666c665666c6656666665666666566666656666665666666566666650
5666666566ccc65633336566ccc6566ccc6566ccc6566ccc6566ccc65dddddd5dddddd566ccc6566ccc656666665666666566666656666665666666566666650
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555550
5666666566cc66566cc665666e66566cc665dddddd5dddddd5dddddd5dddddd5dddddd5dddddd566cc6656666665666666566666656666665666666566666650
56666665666c665666c66566ee665666c665dddddd5dddddd5dddddd5dddddd5dddddd5dddddd5666c6656666665666666566666656666665666666566666650
56666665666c665666c6656eee665666c665dddddd5dddddd5dddddd5dddddd5dddddd5dddddd5666c6656666665666666566666656666665666666566666650
56666665666c665666c665eeee665666c665dddddd5dddddd5dddddd5dddddd5dddddd5dddddd5666c6656666665666666566666656666665666666566666650
56666665666c665666c665666e665666c665dddddd5dddddd5dddddd5dddddd5dddddd5dddddd5666c6656666665666666566666656666665666666566666650
5666666566ccc6566ccc65666e66566ccc65dddddd5dddddd5dddddd5dddddd5dddddd5dddddd566ccc656666665666666566666656666665666666566666650
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555550
5666666566cc66566cc66566cc66566cc665dddddd566cc66566cc66566cc66566cc665663366566886656666665666666566666656666665666666566666650
56666665666c665666c665666c665666c665dddddd5666c665666c665666c665666c665636636568668656666665666666566666656666665666666566666650
56666665666c665666c665666c665666c665dddddd5666c665666c665666c665666c665666636566668656666665666666566666656666665666666566666650
56666665666c665666c665666c665666c665dddddd5666c665666c665666c665666c665666366566688656666665666666566666656666665666666566666650
56666665666c665666c665666c665666c665dddddd5666c665666c665666c665666c665663666568668656666665666666566666656666665666666566666650
5666666566ccc6566ccc6566ccc6566ccc65dddddd566ccc6566ccc6566ccc6566ccc65633336566886656666665666666566666656666665666666566666650
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555550
566cc66566cc665dddddd566cc66566cc66566cc66566cc665666e66566cc66566cc665666e665666e6656666665666666566666656666665666666566666650
5666c665666c665dddddd5666c665666c665666c665666c66566ee665666c665666c66566ee66566ee6656666665666666566666656666665666666566666650
5666c665666c665dddddd5666c665666c665666c665666c6656eee665666c665666c6656eee6656eee6656666665666666566666656666665666666566666650
5666c665666c665dddddd5666c665666c665666c665666c665eeee665666c665666c665eeee665eeee6656666665666666566666656666665666666566666650
5666c665666c665dddddd5666c665666c665666c665666c665666e665666c665666c665666e665666e6656666665666666566666656666665666666566666650
566ccc6566ccc65dddddd566ccc6566ccc6566ccc6566ccc65666e66566ccc6566ccc65666e665666e6656666665666666566666656666665666666566666650
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555550
5dddddd5dddddd5dddddd566cc665666e66566cc66566cc66566cc66566cc66566cc665663366566886656666665666666566666656666665666666566666650
5dddddd5dddddd5dddddd5666c66566ee665666c665666c665666c665666c665666c665636636568668656666665666666566666656666665666666566666650
5dddddd5dddddd5dddddd5666c6656eee665666c665666c665666c665666c665666c665666636566668656666665666666566666656666665666666566666650
5dddddd5dddddd5dddddd5666c665eeee665666c665666c665666c665666c665666c665666366566688656666665666666566666656666665666666566666650
5dddddd5dddddd5dddddd5666c665666e665666c665666c665666c665666c665666c665663666568668656666665666666566666656666665666666566666650
5dddddd5dddddd5dddddd566ccc65666e66566ccc6566ccc6566ccc6566ccc6566ccc65633336566886656666665666666566666656666665666666566666650
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555550
5dddddd5dddddd5dddddd566cc66566cc66566cc665dddddd5dddddd5dddddd5dddddd566cc66566886656666665666666566666656666665666666566666650
5dddddd5dddddd5dddddd5666c665666c665666c665dddddd5dddddd5dddddd5dddddd5666c66568668656666665666666566666656666665666666566666650
5dddddd5dddddd5dddddd5666c665666c665666c665dddddd5dddddd5dddddd5dddddd5666c66566668656666665666666566666656666665666666566666650
5dddddd5dddddd5dddddd5666c665666c665666c665dddddd5dddddd5dddddd5dddddd5666c66566688656666665666666566666656666665666666566666650
5dddddd5dddddd5dddddd5666c665666c665666c665dddddd5dddddd5dddddd5dddddd5666c66568668656666665666666566666656666665666666566666650
5dddddd5dddddd5dddddd566ccc6566ccc6566ccc65dddddd5dddddd5dddddd5dddddd566ccc6566886656666665666666566666656666665666666566666650
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555550
5dddddd5dddddd566cc66566cc6656633665663366566336656633665663366566336656633665666e6656666665666666566666656666665666666566666650
5dddddd5dddddd5666c665666c665636636563663656366365636636563663656366365636636566ee6656666665666666566666656666665666666566666650
5dddddd5dddddd5666c665666c66566663656666365666636566663656666365666636566663656eee6656666665666666566666656666665666666566666650
5dddddd5dddddd5666c665666c6656663665666366566636656663665666366566636656663665eeee6656666665666666566666656666665666666566666650
5dddddd5dddddd5666c665666c6656636665663666566366656636665663666566366656636665666e6656666665666666566666656666665666666566666650
5dddddd5dddddd566ccc6566ccc656333365633336563333656333365633336563333656333365666e6656666665666666566666656666665666666566666650
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555550
566cc66566cc6656688665666e6656688665666e665666e6656166165666e665666e665663366566666656666665666666566666656666665666666566666650
5666c665666c665686686566ee665686686566ee66566ee665616616566ee66566ee665636636566666656666665666666566666656666665666666566666650
5666c665666c66566668656eee66566668656eee6656eee66561661656eee6656eee665666636566666656666665666666566666656666665666666566666650
5666c665666c6656668865eeee6656668865eeee665eeee6656111165eeee665eeee665666366566666656666665666666566666656666665666666566666650
5666c665666c6656866865666e6656866865666e665666e6656666165666e665666e665663666566666656666665666666566666656666665666666566666650
566ccc6566ccc656688665666e6656688665666e665666e6656666165666e665666e665633336566666656666665666666566666656666665666666566666650
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555550
56666665666666566666656666665666666566666656666665666666566666656666665666666566666656666665666666566666656666665666666566666650
56666665666666566666656666665666666566666656666665666666566666656666665666666566666656666665666666566666656666665666666566666650
56666665666666566666656666665666666566666656666665666666566666656666665666666566666656666665666666566666656666665666666566666650
56666665666666566666656666665666666566666656666665666666566666656666665666666566666656666665666666566666656666665666666566666650
56666665666666566666656666665666666566666656666665666666566666656666665666666566666656666665666666566666656666665666666566666650
56666665666666566666656666665666666566666656666665666666566666656666665666666566666656666665666666566666656666665666666566666650
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555550
56666665666666566666656666665666666566666656666665666666566666656666665666666566666656666665666666566666656666665666666566666650
56666665666666566666656666665666666566666656666665666666566666656666665666666566666656666665666666566666656666665666666566666650
56666665666666566666656666665666666566666656666665666666566666656666665666666566666656666665666666566666656666665666666566666650
56666665666666566666656666665666666566666656666665666666566666656666665666666566666656666665666666566666656666665666666566666650
56666665666666566666656666665666666566666656666665666666566666656666665666666566666656666665666666566666656666665666666566666650
56666665666666566666656666665666666566666656666665666666566666656666665666666566666656666665666666566666656666665666666566666650
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555550
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777770
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777770
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777770
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777770

