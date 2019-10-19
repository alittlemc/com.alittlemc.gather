
local strf = string.format
local byte, char = string.byte, string.char
local concat = table.concat

local function stohex(s, ln, sep)
  if #s == 0 then return "" end
  if not ln then
    return s:gsub('.',
    function(c) return strf('%02x', byte(c)) end
    )
  end
  sep = sep or ""
  local t = {}
  for i = 1, #s - 1 do
    t[#t + 1] = strf("%02x%s", s:byte(i),
    (i % ln == 0) and '\n' or sep)
  end
  t[#t + 1] = strf("%02x", s:byte(#s))
  return concat(t)
end --stohex()

local function hextos(hs, unsafe)
  local tonumber = tonumber
  if not unsafe then
    hs = string.gsub(hs, "%s+", "")
    if string.find(hs, '[^0-9A-Za-z]') or #hs % 2 ~= 0 then
      error("invalid hex string")
    end
  end
  return hs:gsub( '(%x%x)',
  function(c) return char(tonumber(c, 16)) end
  )
end

local function rotr32(i, n)
  return ((i >> n) | (i << (32 - n))) & 0xffffffff
end
local function rotl32(i, n)
  return ((i << n) | (i >> (32 - n))) & 0xffffffff
end

local function xor1(key, plain)
  local t = {}
  local ki, kln = 1, #key
  for i = 1, #plain do
    ki = ki + 1
    if ki > kln then ki = 1 end
    t[#t + 1] = char(byte(plain, i) ~ byte(key, ki))
  end
  return table.concat(t)
end

local function xor64(key, plain)
  local concat = table.concat
  local pln = #plain
  local lbbn = pln % 64
  local bn = pln // 64
  if lbbn > 0 then bn = bn + 1 end
  local b = {}
  local t = {}
  local bi = 1
  local ki, kln = 1, #key
  for i = 1, pln do
    b[bi] = char(byte(plain, i) ~ byte(key, ki))
    ki = ki + 1
    if ki > kln then ki = 1 end
    bi = bi + 1
    if bi > 64 then
      bi = 1
      t[#t + 1] = concat(b)
    end
  end
  if lbbn > 0 then
    for i = lbbn+1, 64 do b[i] = nil end
    assert(#b == lbbn)
    t[#t + 1] = concat(b)
  end
  return concat(t)
end


return {stohex = stohex,hextos = hextos,xor1 = xor1,xor64 = xor64,}
