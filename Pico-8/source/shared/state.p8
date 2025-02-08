pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
// interface for states.
// allows for easy customization
// of controls and game states
function template_state()
	local s = {}
	
	s._btn_map={}
	s._btnp_map={}
	
	local function pack_if_needed(arg)
		return type(arg) == "table" and
		       arg or pack(arg)
	end
	
	local function to_key(bt)
		local bit=0
		for b in all(pack_if_needed(bt)) do
			bit |= 1<<b
		end
		return bit
	end
	
	local function set_map(m1,m2,
	                       b,fn,
	                       args)
		local key = to_key(b)
		m1[key]=function()
			fn(unpack(pack_if_needed(args)))
		end
		deli(m2,key)
	end
	
	function s.set_btn(b,fn,args)
		set_map(s._btn_map,
		        s._btnp_map,
		        b,fn,args)
	end
	
	function s.set_btnp(b,fn,args)
		set_map(s._btnp_map,
		        s._btn_map,
		        b,fn,args)
	end
	
	local function check(_btn,bmap)
		local btn_bits = _btn()
		for k,v in pairs(bmap) do
			if btn_bits & k == k then
				v()
			end
		end
	end
	
	function s.controls()
		check(btnp,s._btnp_map)
		check(btn,s._btn_map)
	end
	
	// update/draw functions
	function s.update() end
	function s.draw() end
	
	return s
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
