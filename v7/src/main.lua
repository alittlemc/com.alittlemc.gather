require"import"
import {
  "include",
  "lua.fun"
}

function printT(...)
  for k,v in pairs({...})
    print(k,v)
  end
  Toast.makeText(activity,table.concat({...}," ") , Toast.LENGTH_SHORT )
end

hsn,mulu,sdk=this.getResources().getDimensionPixelSize(luajava.bindClass("com.android.internal.R$dimen")().status_bar_height)--获取状态栏高
,Environment.getExternalStorageDirectory().toString().."/alittlemc/",tonumber(Build.VERSION.SDK)

--return_var="NULL"--{"0","0","0","0"}

import "cjson"
import "bmob"
local val=fr(mulu.."data.json") or false

if val then
  data=cjson.decode(val)
  val=nil
 else
  data={
    ui={
      id={
        [1]=2,
        [2]=1
      },
      theme={
        nbt={
          {0xFF0097A7,0x008080FF,0xFF009688,android.R.style.Theme_Material_Light,true},
          {0xFF3F51B5,0x008080FF,0xFFE91E63,0x7f060001,false},--Google 这样写防止在AndroLua+报错
          {0xFFFF82AB,0x008080FF,0xFFFF82AB,0x7f060003,false},

          {0xFF2096F3,0x008080FF,0xFFE91E63,0x7f060002,false},
          {0xFF303030,0x008080FF,0xFF009688,android.R.style.Theme_Material,true},
        },
        ber={true,false},
        id=1,
        name={"默认","深蓝-亮粉","全粉红","天蓝-亮粉","*夜间"},
        w_h=false,
      },
      image=false,
      icon1={
        [1]="files/btn1.png",
        [2]=true,
        [3]=""
      },
      icon2={
        [1]="files/btn2.png",
        [2]=false,
        [3]=""
      },
      icon_x={
        [1]="files/xfan.png",
        [2]="files/xfan.png"
      },
      coord={
        [1]="",
        [2]="",
        [3]=""
      }
    },
    load={
      _id={
        [1]=true,
        [2]=math.random(1,1000),
        [3]=""
      },
      diy=false,
      guide=true
    }
  }
end

--是否为夜间主题
local val=data.ui.theme.id
if not tonumber(val) then
  val=1
  data.ui.theme.id=1
end
if val==#data.ui.theme.name then--最后一个主题为黑色
  theme_n,theme_l="#ffffffff","#FF303030"
  theme_n_int,theme_l_int=0xffffffff,0xff303030
  val_=true
 else
  theme_n,theme_l="#FF303030","#ffffffff"
  theme_n_int,theme_l_int=0xff303030,0xffffffff
end

--是否横屏(test)
if data.ui.theme.w_h then
  hh,wh=activity.getWidth(),activity.getHeight()
  activity.setRequestedOrientation(0)
 else
  wh,hh=activity.getWidth(),activity.getHeight()
end
--mGlobal={}

--主题色赋值以及主题
color1=tointeger(data.ui.theme.nbt[val][1] or 0xFF3F51B5)
color2=tointeger(data.ui.theme.nbt[val][2] or 0x008080FF)
color3=tointeger(data.ui.theme.nbt[val][3] or 0xFFE91E63)

mTheme=data.ui.theme.nbt[val][4] or android.R.style.Theme_Material_Light
activity.setTheme(mTheme)
if data.ui.theme.nbt[val][5] then
  activity.ActionBar.hide()
end

import {
  "lua.code_diy_split",
  "link.CD"
}

--getRgb(0,0,0,0)
--getRgb(0,0,0,0)

--[[task(1000,function()
local val=data["load"]["_id"][3]
if #val>4 and fs(mulu.."QQ_icon.png",false)<=1000 then
  http.download("http://q1.qlogo.cn/g?b=qq&nk="..val.."&s=640",mulu.."QQ_icon.png")
end
end)]]

--隐藏状态栏
activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)
--设置缓入动画
--activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS).setStatusBarColor(0xff4285f4);
activity.overridePendingTransition(android.R.anim.slide_in_left,android.R.anim.fade_out)
--关闭输入法
activity.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_PAN)

import {
  "build",
  "lua.setting"
}

if val_ then
  mn.setColorFilter(0xaa303030)
  chI.setColorFilter(0xaa303030)
end
val_=nil

local val=data.ui.image
if val then
  setIm(mn,val)
  setIm(chI,val)
 else
  setBz(mn,chI)
end

--ui_Im(tass,data["ui"]["icon_x"][1])--悬浮按钮图片
--ui_Im(tass_,data["ui"]["icon_x"][2])
--ui_Im(btn1,data["ui"]["icon1"][1])--两个按钮
ui_Mod(bity1,data.ui.icon1[2])
--ui_Im(btn2,data["ui"]["icon2"][1])
ui_Mod(bity2,data.ui.icon2[2])

function btn1.onClick(view)
  load(data.ui.icon1[3])()
end

function btn2.onClick(view)
  load(data.ui.icon2[3])()
end

task(1,function()
  DH(pack_1,"Y",{hh*0.84,hh*1.5},1,"f")
end)

--title_top.Text=data.ui.title[1]--设置标题
title_top.getPaint().setFakeBoldText(true)

import "main_ui"

Alm_Main()

--CD_T{t="通知",aly="已经完成下载"}.show()

--appDownload=require "lua.download"

collectgarbage("collect")


--[[bmob_main:update("alittlemc","HwlkeeeB",{file="sdcard/alittlemc/data.json"},function(a,b)
  print(a,cjson.encode(b))
  end)]]

--[[bmob_main:upload("sdcard/alittlemc/data.json",function(a,b)
  print(a,cjson.encode(b))
end)]]
--[[
str=Scanner("s4,g5,y0,z12")
.useDelimiter("[^0-9]+")
s=0
while str.hasNext() do
  s=s+str.nextInt()
end
]]


--CD{aly=tostring(Calendar.getInstance().get(Calendar.MONTH)+1),mod=1,t="Test",b={"确定"}}
--print(#luajava.coding("123","","UTF-8"))
--print(Date(Calendar.getInstance().set(100,3,10).currentTimeMillis()))

