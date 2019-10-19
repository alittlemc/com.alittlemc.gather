local format,sub,gsub,concat,match,find=string.format,string.sub,string.gsub,table.concat,string.match,string.find

function debug_f(bool,r,u)
  if bool and r then
    r()
   elseif u then
    u()
  end
end

function debug_r(bool,r,u)
  return (bool and {r} or {u})[1]
end

function string:split2(sep)
  local sep, fields=sep or "\t",{}
  local pattern=string.format("([^%s]+)",sep)
  self:gsub(pattern,function(c) fields[#fields+1]=c end)
  return fields
end

function split1(string,sep)
  local sep,fields=sep or "\t",{}
  local pattern=string.format("([^%s]+)",sep)
  string.gsub(string,pattern,function(c) fields[#fields+1]=c end)
  return fields
end

function split(str,strid)
  local stri,arri,arr=1,1,{}
  while true do
    local stri_=find(str,strid,stri)
    if not stri_ then
      arr[arri]=sub(str,stri,string.len(str))--最后一个
      break
    end
    arr[arri]=sub(str,stri,stri_-1)
    stri=stri_+string.len(strid)
    arri=arri+1
  end
  return arr
end

function jishu(a,c)
  return tointeger((#a-#gsub(a,c,""))/#c)
end

local test_var=0
function onKeyDown(c,e)
  onKeyDown_Func(c,e)
  if string.find(tostring(e),"KEYCODE_BACK") ~= nil then
    if test_var+2 > tonumber(os.time()) then
      close()
     else
      Toast.makeText(activity,"再按一次返回键退出" , Toast.LENGTH_SHORT )
      .show()
      test_var=tonumber(os.time())
    end
    return true
  end
  --if code==82 then clear() end
end

function colordx(a)
  return "#"..format("%x",tonumber(a))
end

function app_bool(n)
  return (pcall(function() activity.getPackageManager().getPackageInfo(tostring(n),0) end)
  and {true} or {false})[1]
end

function getJqb()
  return tostring(activity.getSystemService(Context.CLIPBOARD_SERVICE).getText())
end

function setJqb(a)
  activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(tostring(a))
end

function onResume()
  onResume_Func()
  local a,b="alm:guide}",getJqb()
  if data["load"]["guide"] and b and tonumber(jishu(b,a))==2 then
    CD{mod={true,wh},
      t="向导模式",
      aly={LinearLayout;
        layout_height="-1";
        padding="10dp";
        orientation="vertical";
        layout_width="-1";
        {
          LuaEditor;
          layout_width="-1";
          id="et";
          text="--已经从剪切板获取代码如下\n"..string.match(b,"{"..a.."(.-){/"..a) or "";
          layout_height="75%h",--"70%h";
          --hint="在此输入代码";
        };
      },
      --g=1,
      c=true,
      b={"运行","关闭"},

      funs={function(d)
          setJqb("")
        end,
        function(d,v)
          switch(v.Text)
           case "运行"
            load(et.Text)()
          end
        end}
    }.show()
  end
end
--{alm:guide} func {/alm:guide}

function onConfigurationChanged(e)
  if onConfigurationChanged_Func then
    onConfigurationChanged_Func(e)
   else
    codedo_err("onConfigurationChanged_Func")
  end
end

function base64(sr,mod)--java
  import "android.util.Base64"
  local mod=(mod==0 and {Base64.DEFAULT}or{Base64.NO_PADDING})[1]
  return Base64.encodeToString(String(sr).getBytes(),mod)
end

--local b64=require "codelua/b64"

function qq_xml(t)
  local title,content,url_0=base64(t.t) or "",base64(t.aly) or "",base64(t.url_0) or ""
  local url_1=(t.url_1 and{base64(t.url_1)}or{""})[1]
  local url_2=(t.url_2 and{base64(t.url_2)}or{""})[1]
  local app_name=(t.app_name and{base64(t.app_name)}or{"6ZuG5ZCI"})[1]
  local url=concat({"mqqapi://share/to_fri?file_type=news&src_type=web&version=1&share_id=",
    app_id,
    "&url="..url_0,
    "&previewimageUrl=",
    url_1,
    "&image_url=",
    url_2,
    "&title=",
    title,
    "&description=",
    content,
    "&callback_type=scheme&thirdAppDsplayName=UVE&app_name=",
    app_name,
    "&shareType=0"})
  --setJqb(url)
  activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
end
--qq_xml{t="标题",aly="概述",url_0="目标url",url_1="预览图片url",url_2="图片url",app_name="软件名",app_id="软件id"}
--qq_xml("我是标题","我在这里怎么写都可以","https://github.com/alittlemc/org.alittlemc.bug/","","http://q1.qlogo.cn/g?b=qq&nk=2358742797&s=640","UC浏览器",100951776)

function tableChange1(sr,a,b)
  local la,lb,len=#a,#b,0
  if la>0 and lb>0 and type(a)=="table" and type(b)=="table" then
    len=(la>=lb and{la}or{lb})[1]
    for i=1,len,1 do
      sr=gsub(sr,a[i],b[i])
    end
  end
  return sr
end

function tableChange2(sr,a)
  local ls,len=#a,0
  if ls>0 and type(a)=="table" then
    len=(ls%2==0 and {ls} or {ls-1})[1]
    for i=1,len,2 do
      sr=gsub(sr,a[i],a[i+1])
    end
  end
  return sr
end

function qq_lt(q)
  url="mqqwpa://im/chat?chat_type=wpa&uin="..q
  activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
end

function qq_team(q)
  url="mqqapi://card/show_pslcard?src_type=internal&version=1&uin="..q.."&card_type=group&source=qrcode"
  activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
end

function intent_url(url)
  viewIntent = Intent("android.intent.action.VIEW",Uri.parse(url))
  activity.startActivity(viewIntent)
end

function unzip(zippath,outfilepath,filename)
  local time=os.clock()
  task(function(zippath,outfilepath,filename)
    require "import"
    import "java.util.zip.*"
    import "java.io.*"
    local file = File(zippath)
    local outFile = File(outfilepath)
    local zipFile = ZipFile(file)
    local entry = zipFile.getEntry(filename)
    local input = zipFile.getInputStream(entry)
    local output = FileOutputStream(outFile)
    local byte=byte[entry.getSize()]
    local temp=input.read(byte)
    while temp ~= -1 do
      output.write(byte)
      temp=input.read(byte)
    end
    input.close()
    output.close()
  end,zippath,outfilepath,filename,

  debug_r(data.load._id[1]=="R",function
    print(os.date().."解压完成,耗时 "..os.clock()-time.." s")
  end,nil)
  )
end

--[[print(getSharedData("ueser",true))
setSharedData("ueser",true)]]

--调用其它程序打开文件
function OpenFile(path,mod)--目录,修改无时的打开方式
  local f=tostring(File(path).Name)
  local ExtensionName=match(f,"%.(.+)")
  local Mime=MimeTypeMap.getSingleton().getMimeTypeFromExtension(ExtensionName) or
  MimeTypeMap.getSingleton().getMimeTypeFromExtension(mod)
  if Mime then
    intent = Intent()
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
    intent.setAction(Intent.ACTION_VIEW)
    intent.setDataAndType(Uri.fromFile(File(path)),Mime)
    activity.startActivity(intent);
   else
    print("找不到可以用来打开此文件的程序")
  end
end

--获取运营商名称
--import "android.content.Context"
--print(activity.getSystemService(Context.TELEPHONY_SERVICE).getNetworkOperatorName())
--READ_PHONE_STATE
--print(os.date("%Y-%m-%d %H:%M:%S"))

function onDestroy()
  onDestroy_Func()
  if data then
    data["ui"]["theme"][1],data["ui"]["theme"][2],data["ui"]["theme"][3]=color1,color2,color3
    fw(mulu.."data.json",cjson.encode(data))
   else
    fd(mulu.."data.json")
  end
end

function sgg(s,i,j)
  local o=utf8.offset
  local i,j,n,m=tonumber(i),tonumber(j),o(s,i),
  ((j or -1)==-1 and -1) or o(s,j+1)-1
  return sub(s,n,m)
end

function notnil(a)
  return (a and {a} or {""})[1]
end

function match0(sr,a,b)
  n=sr:match(a..((a=="" or b=="") and{"(.+)"} or {"(.-)"})[1]..b)
  return (n and {n} or {""})[1]
end

function shell(cmd)
  local p=io.popen(format('%s',cmd),"r")
  local s=p:read("*a")
  p:close()
  --[[for cnt in p:lines() do
    print(cnt)
  end]]
  return s
end

function randomJava(min,max,seed)
  return (seed and Random(seed) or Random()).nextInt(max or 100000)+(min or 0)
end

function getChar(i)
  return ((type(i)=="integer" or type(i)=="number")and
  {String.valueOf(char(i>0 and i or 32))} or
  {int(String(#i>0 and i or" ").charAt(0))})[1]
end

--[[
--print(randomJava(false,false,0))
tox=require "openSource.NumConvert.main"
print(tox.getChar("_"),tox.getChar(":"),"`"=="'","$"=="$")
--print(tox.rtor("123456789",10,tox.length))--tox.rtor("abcdef",16,10),10,16))
print(tox.rtor(tox.rtor("{,}` ",tox.length,80),80,tox.length))
--print(tox.rtor(tox.rtor("ylgV7778",tox.getChar("Z"),tox.length),tox.length,tox.getChar("Z")))
--ylgV7778
]]
--print(String("5").charAt(0))

function setBz(...)
  for i,a in ipairs({...}) do
    wallpaperManager = WallpaperManager.getInstance(this)
    wallpaperDrawable = wallpaperManager.getDrawable()
    a.setDrawingCacheEnabled(true)
    a.setImageDrawable(wallpaperDrawable)
  end
end

function DH(id,mod,sr,time,fool)
  if fool=="f" or fool=="F" then
    ObjectAnimator().ofFloat(id,mod,sr).setDuration(time).start()
   elseif fool=="i" or fool=="I" then
    ObjectAnimator().ofInt(id,mod,sr).setDuration(time).start()
  end
end

--打开程序,进程
function start_app(s1,s2)
  activity.startActivity(Intent().setComponent(ComponentName(s1,s2)))
end

function del_app(pack)
  task(function(pack)
    activity.startActivity(Intent(Intent.ACTION_DELETE,Uri.parse("package:"..pack)))
  end,pack,function()
    Toast.makeText(activity,"正在卸载"..pack, Toast.LENGTH_SHORT )end)
end

--文件
function fr(f)--j
  F,n=io.open(f,"r")--文件不存在or是否为文件夹
  return (n and {false} or {(not File(f).isDirectory() and {F:read("*a")} or {false})[1]})[1]
end

function fw(a,b)--j
  task(function(a,b)
    f=File(tostring(File(tostring(a)).getParentFile())).mkdirs()--创建文件夹
    io.open(tostring(a),"w"):write(tostring(b)):close()
  end,a,b,function()end)
end

function fw_a(f,t)
  if not fbool(f) then
    fw(f,"")
  end
  task(function(f,t)
    io.open(f,"a+"):write(t):close()
  end,f,t,function()end)
end

function fd(f)
  if fbool(f) then
    task(function(f)
      os.remove(f)
    end,f,function()end)
   else
    return false
  end
end

function fod(fo)
  if fbool(fo) then
    os.execute("rm -r "..fo)
  end
end

function fbool(f)
  return (f and {File(f).exists()} or {false})[1]
end

function fs(f,mod)
  size=File(tostring(f)).length()
  Sizes=Formatter.formatFileSize(activity,size)
  return (mod and {Sizes} or {size})[1]
end

function ft(f)
  return Calendar.getInstance().setTimeInMillis(File(f).lastModified()).getTime().toLocaleString()
end

function fchange(f,str,sr)
  fw(f,gsub(fr(f),str,sr))
end

function fchange_get(f,get,str,sr)
  fw(f,gsub(get,str,sr))
end

function fr_data(f,mod)
  local content,i={},0
  local r = BufferedReader(InputStreamReader(this.openFileInput(f)))
  while r.readLine() do
    content[i] = tostring(r.readLine())
    i=i+1
  end
  return (mod and {table.concat(content,"\n")}or{content})[1]
end

function fw_data(f,str)
  -- task(function()
  local time=os.clock()
  task(function(f,str)
    local writer = BufferedWriter(OutputStreamWriter(this.openFileOutput(f,Context.MODE_PRIVATE)))
    writer.write(str)
    writer.close()
  end,f,str,function()end)
end

function fr_line(f)
  local fline_table,i={},1
  for F in io.lines(f) do
    fline_table[i]=F
    i=i+1
  end
  return fline_table
end

function fremove(f,f_)
  task(function(f,f_)
    os.execute("mv "..f.." "..f_)
    --os.rename(tostring(a),tostring(b))
  end,f,f_,function()end)
end

function frename(f,f_)
  task(function(f,f_)
    File(f).renameTo(File(f_))
    --os.rename(tostring(a),tostring(b))
  end,f,f_,function()end)
end

--print(mulu)
--frename(mulu.."data.json",mulu.."alittlemc.apk")
--print(data.load._id[1])
--fremove(mulu.."data.json",mulu.."diy")
--frename(mulu.."",mulu.."/diy")
--[[
function f(a)
  function run()
    print(a)
    a=a+1
  end
end

t=timer(f,0,1000,1)
t.Enabled=false--暂停定时器
--t.Enabled=true--重新定时器
--t.stop()--停止定时器
]]
--print(shell("ls -a /sdcard/"))

--[[获取文件Mime类型
function GetFileMime(name)
import "android.webkit.MimeTypeMap"
ExtensionName=tostring(name):match("%.(.+)")
Mime=MimeTypeMap.getSingleton().getMimeTypeFromExtension(ExtensionName)
return tostring(Mime)
end]]

--print(GetFileMime("/sdcard/a.png"))
--print(tostring(mulu.."data.json"):match("%.(.+)"))

function ui_Vc(id,color)
  if id and color then
    id.setBackgroundColor(color)
  end
end

function ui_Mod(id,fool)
  if id and fool then
    id.setVisibility(View.VISIBLE)
   elseif id and not fool then
    id.setVisibility(View.GONE)
  end
end

function ui_Im(id,mbt)
  if id and mbt then
    id.setImageBitmap(loadbitmap(mbt))
  end
end

function ui_Tc(id,color)
  if id and color then
    id.setTextColor(color)
  end
end

function ui_Ripple(id,color)
  RippleHelper(id).RippleColor=color--0x1CFFFFFF
end

function removeView(id)
  id.getParent().removeView(id)
end

function close(link)
  task(200,function()
    activity.finish()
    if link then
      activity.newActivity(link,android.R.anim.fade_in,android.R.anim.fade_out)
     else
      activity.overridePendingTransition(android.R.anim.fade_in,android.R.anim.fade_out)
    end
  end)
end

function table_copy(orig)
  local copy
  if type(orig)=="table" then
    copy={}
    for orig_key,orig_value in next,orig,nil do
      copy[table_copy(orig_key)]=table_copy(orig_value)--递归copy多维数组
    end
   else -- number, string, boolean, etc
    copy=orig
  end
  return copy
end

--[[
local s=""
for i=0,300,1 do
  s=s.."["..(i-1).."]=\""..String.valueOf(char(i+32)).."\",\n"
end
fw("sdcard/test.txt",s)]]
--print()
