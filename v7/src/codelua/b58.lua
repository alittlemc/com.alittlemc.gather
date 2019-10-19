local spack, sunpack,match,find,gsub= string.pack, string.unpack,string.match,string.find,string.gsub
local byte, char, concat,rep= string.byte, string.char, table.concat,string.rep
--自定义
local b58chars = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"

function setChars(c)
	b58chars=c or "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
end

function encode(s)
	local q, r, b
	local et = {}
	local r = 0
	local zn = 0 	-- number of leading zero bytes in s
	-- assume s is a large, little-endian binary number
	-- with base256 digits (each byte is a "digit")
	local nt = {} -- number to divide in base 256, big endian
	local dt = {} -- result of nt // 58, in base 256
	local bt = {} -- base 58 digits
	local more = true
	for i = 1, #s do 
		b = byte(s, i)
		if more and b == 0 then
			zn = zn + 1
		else
			more = false
		end
		nt[i] = b
	end
	if #s == zn then --take care of strings empty or with only nul bytes
		return rep('1', zn)
	end
	more = true
	while more do
		local r = 0
		more = false
		for i = 1, #nt do
			b = nt[i] + (256 * r)
			q = b // 58
			-- if q is not null at least once, we are good 
			-- for another division by 58
			more = more or q > 0
			r = b % 58
			dt[i] = q
		end
		-- r is the next base58 digit. insert it before previous ones
		-- to get a big-endian base58 number
		table.insert(et, 1, char(byte(b58chars, r+1)))
		-- now copy dt into nt before another round of division by 58
		nt = {}
		for i = 1, #dt do nt[i] = dt[i] end
		dt = {}
	end--while
	-- don't forget the leading zeros ('1' is digit 0 in bitcoin base58 alphabet)
	return rep('1', zn) .. concat(et)
end --encode()

local b58charmap = {}; 
for i = 1, 58 do b58charmap[byte(b58chars, i)] = i - 1  end
function decode(s)
	if find(s, "[^"..b58chars.."]") then
		return nil, "invalid char"
	end
	local zn -- number of leading zeros (base58 digits '1')
	zn = #(match(s, "^(1+)") or "")
	s = gsub(s, "^(1+)", "")
	-- special case: the string is empty or contains only null bytes
	if s == "" then 
		return rep('\x00', zn)
	end
	--
	-- process significant digits
	local dn -- decoded number as an array of bytes (little-endian)
	local d -- base58 digit, as an integer
	local b -- a byte in dn
	local m -- a byte multiplied by 58 (used for product)
	local carry
	dn = { b58charmap[byte(s, 1)] } --init with most significant digit
	for i = 2, #s do --repeat until no more digits
		-- multiply dn by 58, then add next digit
		d = b58charmap[byte(s, i)] -- next digit
		carry = 0
		-- multiply dn by 58
		for j = 1, #dn do
			b = dn[j]
			m = b * 58 + carry
			b = m & 0xff
			carry = m >> 8
			dn[j] = b
		end
		if carry > 0 then dn[#dn + 1] = carry end
		-- add next digit to dn
		carry = d
		for j = 1, #dn do
			b = dn[j] + carry
			carry = b >> 8
			dn[j] = b & 0xff
		end 
		if carry > 0 then dn[#dn + 1] = carry end
	end
	-- now dn contains the decoded number (little endian)
	-- must add leading zeros and reverse dn to build binary string
	local ben = {} -- big-endian number as array of chars
	local ln = #dn
	for i = 1, ln do 
		ben[i] = char(dn[ln-i+1])
	end
	return rep('\x00', zn) .. concat(ben)
end --decode()



return {
	encode=encode,
	decode=decode,
	setChars=setChars
	}



