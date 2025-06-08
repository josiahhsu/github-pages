pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
--[[
each channel is a pair of 4-byte
memory locations, with one addr
for seq nums and one for data

b = base channel num
n = number of channels
]]
function connection(b,n)
	local c = {}
	local base = 0x5f80+b
	local bound = base+((n-1)*8)
	c.seq_num = 1
	c.queue = {}
	
	function c.reset()
		for i = base, bound, 8 do
			poke4(i,0)
		end
	end
	
	function c.queue_send(data)
		add(c.queue,data)
	end
	
	function c.send()
		for i = base, bound, 8 do
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
		for i = base, bound, 8 do
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
	s.connection = connection(0,4)
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
	s.connection = connection(0,4)
	
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
