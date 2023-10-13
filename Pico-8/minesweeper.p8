pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
function _init()
 cls()
 total = 100
 m = 18
 n = 14
 grid = make_grid()
 
 px = 1
 py = 1
 state = init_state()
 t = 0
 mine_placement()
end

function _update()
 state.update()
end

function _draw()
 state.draw()
end
-->8
function make_cell(mine,x,y)
 //makes a cell and determines
 //whether it's marked or not
 local cell = {}
 cell.x = x
 cell.y = y
 cell.spr = 0
 cell.mine = mine
 cell.flagged = false
 cell.revealed = false
 function cell.reveal()
 
 end
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
  t[i] = i<=total
 end
 
 shuffle(t)
 return t
end

function make_grid()
 //makes grid of cells
 local mines = mine_placement()
 local grid = {}
 for i = 1, m do
  grid[i] = {}
  for j = 1, n do
   grid[i][j] = make_cell(deli(mines),i,j)
  end
 end
 return grid
end
-->8
function controls()
 //player controls for movement
 //and revealing cells
 if btnp(0) then
  move_pointer(-1,0)
 elseif btnp(1) then
  move_pointer(1,0)
 elseif btnp(2) then
  move_pointer(0,-1)
 elseif btnp(3) then
  move_pointer(0,1)
 end
 
 if btnp(4) then
  state.z()
 elseif btnp(5) then
  flag_cell(grid[px][py],0)
 end
end

function move_pointer(dx,dy)
 //moves pointer along grid
 local x = px+dx
 local y = py+dy
 if x <= #grid and x>=1 then 
  px += dx
 end
 
 if y <= #grid[1] and y>=1 then 
  py += dy 
 end
end

function open_cell(cell,value)
 //opens a cell, either marking
 //or clearing based on value
 if not cell.revealed and
    not cell.flagged then
  cell.revealed = true
  cell.spr = 20
  if cell.mine then
   reveal_all()
   cell.spr = 19
   state = end_state()
  end
 end
end

function flag_cell(cell)
 if not cell.revealed then
  cell.flagged = not cell.flagged
  cell.spr = (cell.spr + 16)%32
  if cell.spr > 0 then
   total -= 1
  else
   total += 1
  end
 end
end

function reveal_all()
 for i = 1, m do
  for j = 1, n do
   local cell = grid[i][j]
   cell.revealed=true
   if cell.mine and 
      not cell.flagged then
    cell.spr = 18
   elseif cell.flagged and
      not cell.mine then
    cell.spr = 17
   end
  end
 end
end
-->8
function coords(x,y)
 //translates value to partial
 //position on grid 
 return (x-1)*7,y*7+18
end

function draw_cell(x,y)  
 //draws cells on grid
 local cell = grid[x][y]
 x,y = coords(x,y)
 
 spr(cell.spr,x,y)
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
 print("mines:"..total,87,5,5)
 print("time:"..flr(t), 87,16,5)
 for i = 1, m do
  for j = 1, n do
   draw_cell(i,j)
  end
 end
end

function draw_pointer(x,y)
 //draws pointer position
 x,y = coords(x,y)
 rect(x,y,x+7,y+7,9)
end

-->8
function init_state()
 local s = {}
 
 function s.update()
  controls()
 end
 
 function s.draw()
  draw_grid()
  draw_pointer(px, py)
 end
 
 function s.z()
  state = play_state()
  open_cell(grid[px][py],1)
 end
 
 return s
end

function play_state()
 local s = {}
 
 function s.update()
  controls()
  t+=1/30
 end
 
 function s.draw()
  draw_grid()
  draw_pointer(px,py)
 end
 
 function s.z()
  open_cell(grid[px][py],1)
 end
 
 return s
end

function end_state()
 local s = {}
 
 function s.update() end
 
 function s.draw()
  draw_grid()
 end
 
 function s.z() end
 
 return s
end
__gfx__
55555555555555555555555555555555555555555555555555555555555555555555555500000000000000000000000000000000000000000000000000000000
56666665566cc66556633665566886655616616556eeee655662266556dddd655660066500000000000000000000000000000000000000000000000000000000
566666655666c66556366365568668655616616556e666655626666556666d655606606500000000000000000000000000000000000000000000000000000000
566666655666c66556666365566668655616616556eee6655622266556666d655606606500000000000000000000000000000000000000000000000000000000
566666655666c66556663665566688655611116556666e655626626556666d655660066500000000000000000000000000000000000000000000000000000000
566666655666c66556636665568668655666616556666e655626626556666d655606606500000000000000000000000000000000000000000000000000000000
56666665566ccc6556333365566886655666616556eee6655662266556666d655660066500000000000000000000000000000000000000000000000000000000
55555555555555555555555555555555555555555555555555555555555555555555555500000000000000000000000000000000000000000000000000000000
55555555555555555555555555555555555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5666e6655888e88556616165588181855dddddd50000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
566ee665588ee88551111165511111855dddddd50000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
56eee66558eee88556199115581991155dddddd50000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5eeee6655eeee88551199165511991855dddddd50000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5666e6655888e88556111115581111155dddddd50000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5666e6655888e88556161665581818855dddddd50000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555555555555555555555555555555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
57775557777755577557777755575557555757577777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
57777757777775775757777755575757575757577777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
57777577777775775757777757575557557755777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
57775777777775775757777757575757575757577777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
57775557777775775577777757575757575757577777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
57777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
57775757777755577557777775575777555755575557777777775767777767777777777777777777777777777777777777777777777777777777777777777777
57775757777775775757777757775777577757575757777777775767777767777777777777777777777777777777777777777777777777777777777777777777
57777577777775775757777757775777557755575577777777775767777767777777777777777777777777777777777777777777777777777777777777777777
57775757777775775757777757775777577757575757777777775767777767777777777777777777777777777777777777777777777777777777777777777777
57775757777775775577777775575557555757575757777777775767777767777777775557777557777777777777777777777777755577777777777555777777
57777777777777777777777777777777777777777777777777775767777767777777777757777757777777777777777777777777777577777777777775777777
57775557555755575557555755775557557775577777575757575767777767777777777557777757777777777777777777777777755577777777777755777777
57775757577755575757757757577577575757777577575757575767777767777777777757777757777777777777777777777777757777777777777775777777
57775577557757575557757757577577575757777777555755575767777767777777775557777555777777777777777777777777755577777777777555777777
57775757577757575757757757577577575757577577775777575767777767777777777777777777777777777777777777777777777777777777777777777777
57775757555757575757555757575557575755577777775777575767777767777777777777777777777777777777777777777777777777777777777777777777
57777777777777777777777777777777777777777777777777775767557767755577775577777557777755777775577777557777755777775577777557777777
57775557555775575557555757575557755777775557777777775767757767777577777577777757777775777777577777757777775777777577777757777777
57775557757757777577575757575777577775775757777777775767757767755577777577777757777775777777577777757777775777777577777757777777
57775757757755577577555755775577555777775757777777775767757767757777777577777757777775777777577777757777775777777577777757777777
57775757757777577577575757575777775775775757777777775767555767755577775557777555777755577775557777555777755577775557777555777777
57775757555755777577575757575557557777775557777777775767777767777777777777777777777777777777777777777777777777777777777777777777
57777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
57777777777777777777777777777777777777777777777777775767557767755777775557777555777755577775757777557777755777775757777555777777
57777777777777777777777777777777777777777777777777775767757767775777777757777775777757777775757777757777775777775757777775777777
57777777777777777777777777777777777777777777777777775767757767775777775557777555777755577775557777757777775777775557777755777777
57777777777777777777777777777777777777777777777777775767757767775777775777777577777777577777757777757777775777777757777775777777
57777777777777777777777777777777777777777777777777775767555767755577775557777555777755577777757777555777755577777757777555777777
57777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
55555555555555555555555555555555555555555555555555555565555565555555555555555555555555555555555555555555555555555555555555555555
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
67777777777777777777777777775557777557777755777777775769999967555557755555775555577555557755555775555577555557755555775555577777
67777777777777777777777777777757777757777775777777775769777967577757757775775777577577757757775775777577577757757775775777577777
67777777777777777777777777775557777757777775777777775769777967577757757775775777577577757757775775777577577757757775775777577777
67777777777777777777777777775777777757777775777777775769777967577757757775775777577577757757775775777577577757757775775777577777
67777777777777777777777777775557777555777755577777775769999967555557755555775555577555557755555775555577555557755555775555577777
66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777775557777557777755777777775765555567555557755555775555577555557755555775555577555557755555775555577777
77777777777777777777777777777757777757777775777777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777777557777757777775777777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777777757777757777775777777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777775557777555777755577777775765555567555557755555775555577555557755555775555577555557755555775555577777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777775557777557777755577777775765555567555557755555775555577555557755555775555577555557755555775555577777
77777777777777777777777777777757777757777777577777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777775557777757777775577777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777775777777757777777577777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777775557777555777755577777775765555567555557755555775555577555557755555775555577555557755555775555577777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777775577777557777755777777775765555567555557755555775555577555557755555775555577555557755555775555577777
77777777777777777777777777777577777757777775777777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777777577777757777775777777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777777577777757777775777777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777775557777555777755577777775765555567555557755555775555577555557755555775555577555557755555775555577777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777775577777557777755577777775765555567555557755555775555577555557755555775555577555557755555775555577777
77777777777777777777777777777577777757777777577777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777777577777757777755577777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777777577777757777757777777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777775557777555777755577777775765555567555557755555775555577555557755555775555577555557755555775555577777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777557777755577777775765555567555557755555775555577555557755555775555577555557755555775555577777
77777777777777777777777777777777777757777777577777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777777777777757777775577777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777777777777757777777577777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777777777777555777755577777775765555567555557755555775555577555557755555775555577555557755555775555577777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777775577777555777755777777775765555567555557755555775555577555557755555775555577555557755555775555577777
77777777777777777777777777777577777775777775777777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777777577777555777775777777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777777577777577777775777777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777775557777555777755577777775765555567555557755555775555577555557755555775555577555557755555775555577777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777555777755577777775765555567555557755555775555577555557755555775555577555557755555775555577777
77777777777777777777777777777777777775777777577777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777777777777555777755577777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777777777777577777757777777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777777777777555777755577777775765555567555557755555775555577555557755555775555577555557755555775555577777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777575777755777777775765555567555557755555775555577555557755555775555577555557755555775555577777
77777777777777777777777777777777777575777775777777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777777777777555777775777777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777777777777775777775777777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777777777777777777775777755577777775765555567555557755555775555577555557755555775555577555557755555775555577777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777755577775577777557777755777777775765555567555557755555775555577555557755555775555577555557755555775555577777
77777777777777777777777577777577777757777775777777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777755577777577777757777775777777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777757777777577777757777775777777775765777567577757757775775777577577757757775775777577577757757775775777577777
77777777777777777777755577775557777555777755577777775765555567555557755555775555577555557755555775555577555557755555775555577777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777775767777767777777777777777777777777777777777777777777777777777777777777777777

