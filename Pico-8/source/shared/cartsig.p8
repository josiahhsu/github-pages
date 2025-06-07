pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
--[[
b = base channel num
n = number of channels
]]
function connection(b,n)
	local c = {}
	c.base = 0x5f80+b
	c.num = n
	c.seq_num = 1
	c.queue = {}
	
	function c.reset()
		for i = 0x5f80, 0x5fff, 4 do
			poke4(i,0)
		end
	end
	
	function c.queue_send(data)
		add(c.queue,data)
	end
	
	function c.send()
		local rng = c.base+(c.num*4)-1
		for i = c.base, rng, 8 do
			if #c.queue == 0 then
				break
			end
			
			if peek4(i) == 0 then
				local data = deli(c.queue,1)
				poke4(i+4, data)
				poke4(i,c.seq_num)
				c.seq_num += 1
			end
		end
	end
	
	function c.receive()
		local data = {}
		local rng = c.base+(c.num*4)-1
		for i = c.base, rng, 8 do
			if peek4(i) == c.seq_num then
				c.seq_num += 1
				add(data,peek4(i+4))
				poke4(i,0)
			end
		end
		return data
	end
	
	return c
end

function sender()
	local s = {}
	s.connection = connection(0,8)
	s.queue = {}
	
	function s.init()
		s.connection.reset()
	end
	
	function s.queue_send(data)
		s.connection.queue_send(data)
	end
	
	function s.send()
		s.connection.send()
	end
	
	return s
end

function receiver()
	local s = {}
	s.connection = connection(0,8)
	
	function s.receive()
		return s.connection.receive()
	end
	
	return s
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
