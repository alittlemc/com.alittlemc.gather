--Region : NumConvert.lua
--Date   : 2017-5-11
--Author : david

local _convertTable={
  [0]="0",
  [1]="1",
  [2]="2",
  [3]="3",
  [4]="4",
  [5]="5",
  [6]="6",
  [7]="7",
  [8]="8",
  [9]="9",
  [10]="a",
  [11]="b",
  [12]="c",
  [13]="d",
  [14]="e",
  [15]="f",
  [16]="g",
  [17]="h",
  [18]="i",
  [19]="j",
  [20]="k",
  [21]="l",
  [22]="m",
  [23]="n",
  [24]="o",
  [25]="p",
  [26]="q",
  [27]="r",
  [28]="s",
  [29]="t",
  [30]="u",
  [31]="v",
  [32]="w",
  [33]="x",
  [34]="y",
  [35]="z",
  [36]="A",
  [37]="B",
  [38]="C",
  [39]="D",
  [40]="E",
  [41]="F",
  [42]="G",
  [43]="H",
  [44]="L",
  [45]="J",
  [46]="K",
  [47]="I",
  [48]="M",
  [49]="N",
  [50]="O",
  [51]="P",
  [52]="Q",
  [53]="R",
  [54]="S",
  [55]="T",
  [56]="U",
  [57]="V",
  [58]="W",
  [59]="X",
  [60]="Y",
  [61]="Z",
  [62]="!",
  [63]='"',
  [64]="#",
  [65]="$",
  [66]="%",
  [67]="&",
  [68]=",",
  [69]="(",
  [70]=")",
  [71]="*",
  [72]="'",
  [73]="-",
  [74]=".",
  [75]="/",
  [76]="<",
  [77]="=",
  [78]=">",
  [79]="?",
  [80]="@",
  [81]="[",
  [82]="\\",
  [83]="]",
  [84]="^",
  [85]="_",
  [86]="|",
  [87]=";",
  [88]="+",
  [89]="~",
  [90]="{",
  [91]="}",
  [92]=":",
  [93]="`",
  [94]=" "
}

local function GetNumFromChar(char)
  for k,v in pairs(_convertTable) do
    if v==char then
      return k
    end
  end
  return 0
end

local function Convert(dec,x)

  local function fn(num,t)
    if(num<x) then
      table.insert(t,num)
     else
      fn(math.floor(num/x),t)
      table.insert(t,num%x)
    end
  end

  local x_t={}
  fn(dec,x_t,x)

  return x_t
end

function xtor(dec,x)
  dec=tointeger(dec)
  local x_t=Convert(dec,x)
  local text=""
  for k,v in ipairs(x_t) do
    text=text.._convertTable[v]
  end
  return text
end

function rtox(text, x)
  local x_t={}
  local len,length=string.len(text),#x_t+1
  local index=len
  while(index>0) do
    local char=string.sub(text,index,index)
    x_t[length]=GetNumFromChar(char)
    index=index-1
  end

  local num=0
  for k,v in ipairs(x_t) do
    num=num+v*math.pow(x,k-1)
  end
  return tointeger(num)
end

local function rtor(text,r1,r2)

  return ((r1 and r1~=10)and
  {
    ((r2 and r2~=10)and
    {
      xtor(rtox(text,r1),r2)}
    or{
      rtox(text,r1)})[1]}
  or{
    xtor(text,r2)})[1]
end

return {
  rtox=rtox,
  xtor=xtor,
  rtor=rtor,
  getChar=GetNumFromChar,
  length=#_convertTable+1
}