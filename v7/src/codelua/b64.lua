local spack, sunpack,gsub = string.pack, string.unpack,string.gsub
local byte, char, concat = string.byte, string.char, table.concat

local b64chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

local b64charmap = {}; 
for i = 1, 64 do b64charmap[byte(b64chars, i)] = i - 1 end

local MAXLINELN = 72 

function setChars(c)
	b64chars=c or "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
end

local function encode(s, filename_safe)
 local b64chars = b64chars
  local rn = #s % 3
  local st = {}
  local c1, c2, c3
  local t4 = {}
  local lln, maxlln = 1, 72
  for i = 1, #s, 3 do
    c1 = byte(s,i)
    c2 = byte(s,i+1) or 0
    c3 = byte(s,i+2) or 0
    t4[1] = char(byte(b64chars, (c1 >> 2) + 1))
    t4[2] = char(byte(b64chars, (((c1 << 4)|(c2 >> 4)) & 0x3f) + 1))
    t4[3] = char(byte(b64chars, (((c2 << 2)|(c3 >> 6)) & 0x3f) + 1))
    t4[4] = char(byte(b64chars, (c3 & 0x3f) + 1))
    st[#st+1] = concat(t4)
    lln = lln + 4
    if lln > maxlln then st[#st+1] = "\n"; lln = 1 end
  end
  if rn == 2 then
    st[#st] = gsub(st[#st], ".$", "=")
  elseif rn == 1 then 
    st[#st] = gsub(st[#st], "..$", "==")
  end
  local b = concat(st)
  if filename_safe then
    b = gsub(b, "%+", "-")
    b = gsub(b, "/", "_")
    b = gsub(b, "[%s=]", "")
  end
  return b
end --encode

local function decode(b, filename_safe)
 local cmap = b64charmap
  local e1, e2, e3, e4
  local st = {}
  local t3 = {}
  b = gsub(b, "%-", "+")
  b = gsub(b, "_", "/")
  local b = gsub(b, "[=%s]", "") -- remove all whitespaces and '='
  if b:find("[^0-9A-Za-z/+=]") then return nil, "invalid char" end
  for i = 1, #b, 4 do
    e1 = cmap[byte(b, i)]
    e2 = cmap[byte(b, i+1)]
    if not e1 or not e2 then return nil, "invalid length" end
    e3 = cmap[byte(b, i+2)]
    e4 = cmap[byte(b, i+3)]
    t3[1] = char((e1 << 2) | (e2 >> 4))
    if not e3 then
      t3[2] = nil
      t3[3] = nil
      st[#st + 1] = concat(t3)
      break
    end
    t3[2] = char(((e2 << 4) | (e3 >> 2)) & 0xff)
    if not e4 then
      t3[3] = nil
      st[#st + 1] = concat(t3)
      break
    end 
    t3[3] = char(((e3 << 6) | (e4)) & 0xff)
    st[#st + 1] = concat(t3)
  end --for
  return concat(st)
end --decode


return { 
  encode = encode,
  decode = decode,
}