require "import"
local sub,format,gsub,split=string.sub,string.format,string.gsub,string.split
local sqrt,random,pow=math.sqrt,math.random,math.pow
local insert,concat=table.insert,table.concat

function checkChinese(sr) 
  return Pattern.compile("[\\u4E00-\\u9FA5\\uF900-\\uFA2D]").matcher(sr).find()
end

function setT(id,sr)
  id.Text=sr
end

function getT(id)
  return id.Text
end

function r_text(sr,s,e)
  local i=random(s or 1,e or utf8.len(sr))
  return sgg(sr,i,i)
end

function r_arr(a,s,e)
  return a[random(s or 1,e or #a)]
end

function almzipAF(mod,v)
  local a={1,2,3,4,5,6,7,8,9,0}
  local b={"a","b","c","d","e","f"}
  local c={"g","h","i","j","k","l","n","m","o","p","q","r","s","t","v","u","w","x","y","z","A","B","C","D","E","F","G","H","L","J","K","I","N","M","O","P","Q","R","S","T","U","V","W","X","Y","Z","*","/","+","-",":","@","?","!","~","<",">","_","=","{","}","%"}
  local i,ai,bi=1,0,1--61
  while 61~=i do
    ai=ai+1
    if mod==61 then
      v=gsub(v,a[ai]..b[bi],c[i])
    else
      v=gsub(v,c[i],a[ai]..b[bi])
    end
    if ai==10 then
      ai,bi=0,bi+1
    end
    i=i+1
  end
  return v
end

function r_uid()
  local seed,tb={'e','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'},{}
  for i=1,32 do
    tb[i]=seed[random(1,16)]
  end
  local sid=concat(tb)
  return format('%s-%s-%s-%s-%s',sub(sid,1,8),sub(sid,9,12),
  sub(sid,13,16),sub(sid,17,20),sub(sid,21,32))
end

function getDPI(ctx) 
  local dm=DisplayMetrics()
  ctx.getWindowManager().getDefaultDisplay().getMetrics(dm)
  diagonalPixels=sqrt(pow(dm.widthPixels,2)+pow(dm.heightPixels,2))
  return {diagonalPixels/(160*dm.density),160*dm.density,sqrt(pow(dm.widthPixels,2)),sqrt(pow(dm.heightPixels,2))}
end

function daozhi(sr)
  return string.reverse(sr)
end

function daozhi1(sr)
  local n,sc=utf8.len(sr),""
  for i=1,n,1 do
    sc=sgg(sr,i,i)..sc
  end
  return sc
end

function daozhi2(sr)
  local n,sc=utf8.len(sr),{}
  for i=1,n,1 do
    sc[n-i+1]=sgg(sr,i,i)
  end
  return concat(sc)
end

function text_w(sr,arr)
  local v,l="",utf8.len(sr)-1
  for i=1,l,1 do
    v=sgg(sr,i,i)..arr[2]..v
  end
  return arr[1]..v..arr[3]
end

function getK2(sr)
  k=(sr[1]+sr[2]+sr[3]+sr[4])
  k0=(sr[1]*sr[4]-sr[2]*sr[3])^2
  k1=(sr[1]+sr[2])*(sr[3]+sr[4])*(sr[1]+sr[3])*(sr[2]+sr[4]) 
  k=(k*k0)/k1
  if k<= 0.455 then
    i=0.5
  elseif k<= 0.708 then
    i=0.4
  elseif k<= 1.323 then
    i=0.25
  elseif k<= 2.072 then
    i=0.15
  elseif k<= 2.706 then
    i=0.1
  elseif k<= 3.841 then
    i=0.05
  elseif k<= 5.024 then
    i=0.025
  elseif k<= 6.635 then
    i=0.01
  elseif k<= 7.879 then
    i=0.005
  elseif k<= 10.828 then
    i=0.001
  else
    i=0
  end
  return k,i
end

function web_text(sr)
  intent = Intent()
  intent.setAction(Intent.ACTION_WEB_SEARCH)
  intent.putExtra(SearchManager.QUERY,sr) 
  activity.startActivity(intent)
end

local function fact(n)
  if n == 0 then 
    return 1 
  else 
    return n * fact(n-1) 
  end
end

--print(Rec("abc3d","a:我 1 3\nc:我 的 世界\n3:* ** ***"))

--[[a = 10
--[ 执行循环 --]
repeat
   print("a的值为:", a)
   a = a + 1
   if a==13 then
     break
     end
until( a > 15 )]]
--I/O

--import "http"
--gps="116.47,40"

--print(http.get("//uri.amap.com/marker?position=121.287689,31.234527&name=park&src=mypage&coordinate=gaode&callnative=0"))
--print(tostring(http.get("https://uri.amap.com/marker?position="..gps)))
--str="https://detail.m.tmall.com/item.htm?id=562561414780&ali_refid=a3_430733_1007:1151717226:N:1101_0_100:b1a301b57ce397507ff12442f92bedd6&ali_trackid=1_b1a301b57ce397507ff12442f92bedd6&spm=a2113m.8916338.youlike.1&sku_properties=1627207:28341"
--zf.text=http.get("http://www.zhaoxihan.com/api?api=KbToxxJ3kcvG&url="..str)
--print(http.get("http://s7ml.cn/d.php?id="..str))

local function SnaD(n,a1,d)
  return n*a1+n*d*(n-1)/2
end

local function SnaQ(n,a1,q)
  if q==1 then
    return SnaD(n,a1,1)
  else
    return a1*(1-q^n)/(1-q)
  end
end