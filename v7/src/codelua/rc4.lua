-- Copyright (c) 2015  Phil Leblanc  -- see LICENSE file
local spack, sunpack = string.pack, string.unpack
local byte, char, concat = string.byte, string.char, table.concat

local function keysched(key)
  assert(#key == 16)
  local s = {}
  local i,j,ii,jj
  for i = 0, 255 do s[i+1] = i end
  j = 0
  for i = 0, 255 do
    ii = i+1
    j = (j + s[ii] + byte(key, (i % 16) + 1)) & 0xff
    jj = j+1
    s[ii], s[jj] = s[jj], s[ii]
  end
  return s
end

local function step(s, i, j)
  i = (i + 1) & 0xff
  local ii = i + 1
  j = (j + s[ii]) & 0xff
  local jj = j + 1
  s[ii], s[jj] = s[jj], s[ii]
  local k = s[ ((s[ii] + s[jj]) & 0xff) + 1 ]
  return s, i, j, k
end

local function rc4raw(key, plain)
  local s = keysched(key)
  local i, j = 0, 0
  local k
  local t = {}
  for n = 1, #plain do
    s, i, j, k = step(s, i, j)
    t[n] = char(byte(plain, n) ~ k)
  end
  return concat(t)
end

local function rc4(key, plain, drop)
  drop = drop or 256
  local s = keysched(key)
  local i, j = 0, 0
  local k
  local t = {}
  for n = 1, drop do
    s, i, j, k = step(s, i, j)
  end
  for n = 1, #plain do
    s, i, j, k = step(s, i, j)
    t[n] = char(byte(plain, n) ~ k)
  end
  return concat(t)
end

return {
  rc4raw = rc4raw,
  rc4 = rc4,
  encrypt = rc4,
  decrypt = rc4,
}
