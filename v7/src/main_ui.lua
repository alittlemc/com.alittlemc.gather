bmob_main=bmob("24196332bdcaa40d12f2791eeba75bed","c7c4bd4b210d96bdbf6512187432bf7a")
local dat={}
adp=LuaMultiAdapter(this,dat,setting)
adp.add{__type=1,title="布局"}
adp.add{__type=2,subtitle="主题",message="修改日/夜间主题,设置主题色\n(重新启动生效)"}
adp.add{__type=4,subtitle="*横屏",message="为平板准备的功能\n(注意,还没有弄好)",status={Checked=Boolean.valueOf(data.ui.theme.w_h or false)}}

List_Add()
adp.add{__type=1,title="脚本/插件"}
adp.add{__type=4,subtitle="预加载",message="省去加载提高性能,但是新加入的脚本不会被读取",status={Checked=Boolean.valueOf(data.load.diy or false)}}
adp.add{__type=2,subtitle="获取在线脚本",message="通过网络获取作者提供的脚本,为了避免服务器负载过高,请不要频繁操作"}
adp.add{__type=2,subtitle="管理本地脚本",message="管理(删除/修改源码)diy目录中的脚本"}
--adp.add{__type=4,subtitle="自动更新",message="该功能暂时关闭",status={Checked=Boolean.valueOf(false)}}

adp.add{__type=1,title="测试功能(home)"}
adp.add{__type=4,subtitle="剪切板向导",message=Html.fromHtml("允许通过<b>剪切板</b>获取可执行的代码,并且执行"),status={Checked=Boolean.valueOf(data.load.guide or false)}}
adp.add{__type=2,subtitle="远程向导",message="从服务器获取开发者提供的代码"}
adp.add{__type=2,subtitle="执行代码",message="在编辑框中输入代码用于执行"}
adp.add{__type=2,subtitle="优化内存",message="手动清理一些无用内容collectgarbage(\"collect\")"}

--local a,b,c,d=getDPI(activity)
--adp.add{__type=2,subtitle="density",message=a.."_"..b.."_\n"..c.."_"..d}

--adp.add{__type=6,subtitle="你好",message="hhh",imagesrc="icon.png"}
--[[adp.add{__type=1,title="彩蛋"}
if app_bool("com.mojang.minecraftpe") then adp.add{__type=7,subtitle="Minecraft(我的世界)",message="你好世界"}end
if app_bool("com.coolapk.market") then adp.add{__type=7,subtitle=Html.fromHtml("<font color='#0fa05a'>酷安</font>"),message="酷安基佬好评!"}end
if app_bool("cn.com.shouji.market") then adp.add{__type=7,subtitle=Html.fromHtml("<font color='#0fa05a'>手机乐园</font>"),message="乐园还没倒闭好评!"}end
if app_bool("com.sf.ALuaGuide") then adp.add{__type=7,subtitle=Html.fromHtml("<font color='#E91E63'>alua手册</font>"),message="你也是个ALua的开发者"}end
]]
adp.add{__type=1,title="其他"}
adp.add{__type=6,subtitle="关于",message="包名:"..activity.getPackageName().."\n版本:1.1-(2019-10-1)",imagesrc="icon.png"}

if app_bool("com.eg.android.AlipayGphone") then adp.add{__type=6,subtitle=Html.fromHtml("<b>支付宝捐赠</b>"),message="你的支持是我的开发的动力"}end
--adp.add{__type=7,subtitle="",message="alittlemc"}
adp.add{__type=2,subtitle=Html.fromHtml("<b>重置/卸载</b>"),message="如果遇到bug重置一些配置文件,当然也提供了卸载方法"}
cehuait.setAdapter(adp)

--adp.remove(1)
--[[adp.insert(3,{__type=3,subtitle="关于软件"})
adp.notifyDataSetChanged()]]

cehuait.setOnItemClickListener(AdapterView.OnItemClickListener{
  onItemClick=function(id,v,zero,one)
    local val=v.Tag.subtitle.Text
    switch(val)
     case "主题"

      CD_L{t="主题",
        mod=1,
        c=false,
        b={"重启","关闭"},
        funs={false,function(d,v)switch(v.Text)case "重启" close() end end},
        funsl={
          function(f)
            f.add{__type=1,title="当前主题:"..data["ui"]["theme"]["name"][data["ui"]["theme"]["id"]]}
            for k,v in pairs(data["ui"]["theme"]["name"]) do
              --f.add{__type=6,subtitle="关于",message="包名:"..activity.getPackageName().."\n版本:0.1-(2019-3-2)",imagesrc="icon.png"}
              f.add{__type=8,subtitle=k..":"..v}
            end
          end,
          function(t,i,o,f)
            data["ui"]["theme"]["id"]=o
            f.insert(0,{__type=1,title="当前主题:"..data["ui"]["theme"]["name"][o]})
            f.remove(1)
          end}
      }

     case "*横屏"

      if v.Tag.status.Checked then
        data["ui"]["theme"]["w_h"]=false
        dat[one].status["Checked"]=false
       else
        data["ui"]["theme"]["w_h"]=true
        dat[one].status["Checked"]=true
      end

     case "剪切板向导"

      if v.Tag.status.Checked then
        data.load.guide=false
        dat[one].status["Checked"]=false
       else
        data.load.guide=true
        dat[one].status["Checked"]=true
      end
     case "远程向导"

      CD{t="输入密钥",mod=1,aly={
          LinearLayout;
          orientation="vertical";
          layout_width="-1";
          {EditText;
            text="";
            hint="请输入的8位密钥";
            layout_marginTop="0dp";
            layout_width="-1";
            layout_gravity="center",
            layout_marginRight="16dp";
            layout_marginLeft="16dp";
            id="edit";
            singleLine="true";
            --digits="2",--"0123456789abcdefghigklmnopqrstuvwxyzQWERTYUIOPASDFGHJKLZXCVBNM";
          };
        },b={"获取","关闭"},funs={false,
          function(d,v)
            if v.Text=="获取" then
              local e=edit.Text
              --edit.setKeyListener(DigitsKeyListener.getInstance(“123456xyz”))
              if #e==8 then
                loading("正在与服务器通信","请确认网络连接正常,并且不能频繁操作")
                bmob_main:query("help",e,function(a,b)
                  if b.text then
                    codedo(e,b.text)
                   else
                    CD_T{t="出错 err:"..(a or "null"),time=200000,aly=cjson.encode(b)}
                  end
                end)
               else
                print("密钥长度错误")
              end
            end
            --CD_T{t="出错 err:-0(输入错误)",aly="密钥长度是8位,请确认是否正确"}.show()
          end}
      }

     case "预加载"

      if v.Tag.status.Checked then
        data.load.diy=false
        dat[one].status["Checked"]=false
       else
        data.load.diy=true
        dat[one].status["Checked"]=true
      end

     case "优化内存"

      local a=collectgarbage("count")
      collectgarbage("collect")
      printT(a-collectgarbage("count"))
      a=nil

     case "获取在线脚本"

      local function fun(val_l)
        --print(cjson.encode(val_l))

        CD_L{t="在线获取",mod=2,funsl={
            function(f)
              f.add{__type=1,title="点击进入安装"}
              for k,v in pairs(val_l) do
                --f.add{__type=6,subtitle="关于",message="包名:"..activity.getPackageName().."\n版本:0.1-(2019-3-2)",imagesrc="icon.png"}
                f.add{__type=2,subtitle=v.link.."("..v.updatedAt..")",message=v.about}
              end
            end,

            function(a,b,c)
              --g.hide()
              codedo("运行代码安装",val_l[c].name)
            end},c=true
        }
      end

      local v=mulu.."list/query"..os.date("%j")..".json"

      if not fbool(v) then
        loading("正在与服务器通信")
        bmob_main:query("alittlemc","",function(a,b)
          --setJqb(cjson.encode(b))

          local val_l=b.results or {[1]={updatedAt="现在",about="获取失败:"..a..",点击可尝试重置",link="出错!",name="--未能成功通信服务器,运行后请再一次点击\"获取在线脚本\"尝试重新刷新\nfod(\""..mulu.."list/\")\ncd.hide()"}}
          --print(cjson.encode(val_l))
          fod(mulu.."list/")
          fw(v,cjson.encode(val_l))
          fun(val_l)end)
       else
        local f=cjson.decode(fr(v)) or false
        fun(type(f)=="table" and f or {[1]={updatedAt="现在",about="内容过期损毁!点击可尝试重置",link="出错!",name="--执行尝试重新刷新,运行后请再一次点击\"获取在线脚本\"\nfod(\""..mulu.."list/\")\ncd.hide()"}})
      end

     case "管理本地脚本"

      local ls_d=split(shell("ls "..mulu.."diy"),"\n")

      CD_L{t="卸载",mod=2,funsl={
          function(f)
            f.add{__type=1,title="点击删除"}
            for k,v in pairs(diyname_all) do
              --f.add{__type=6,subtitle="关于",message="包名:"..activity.getPackageName().."\n版本:0.1-(2019-3-2)",imagesrc="icon.png"}
              f.add{__type=2,subtitle=v.."("..ls[k]..")",message=diyname_about[k]}
            end
          end,
          function(a,b,c)
            --g.hide()
            codedo("运行代码即可卸载(重启后更新列表)","fod(\""..mulu.."diy/"..ls_d[c].."\")\ncd.hide()")
          end},c=true
      }

     case "重置/卸载"

      clear()

     case "支付宝捐赠"

      CD{t="支付宝捐赠",c=false,b={"捐赠","关闭"},aly="感谢您的支持,一分也是爱,你的支持我会牢记于心,谢谢啦",funs={false,function(d,v)
            if v.Text=="捐赠" then
              activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(tostring(string.gsub("alipays://platformapi/startapp?saId=10000007&clientVersion=3.7.0.0718&qrcode=https%3A%2F%2Fqr.alipay.com%2F{code}%3F_s%3Dweb-other","{code}","TSX085035RFBR3QOWC20CD3")))))
            end
          end}}

     case "关于"

      CD{t="关于",c=false,b={"联系我","关闭"},aly={
          LinearLayout;
          layout_height="-2";
          layout_width="-1";
          gravity="center";
          orientation="vertical";
          {ImageView;
            --padding="20dp";
            src="icon.png";
          };
          {TextView;
            layout_margin="20dp";
            text=Html.fromHtml("1.）<b>感</b>谢您的使用，本软件开源在github，核心是脚本，如果想了解更多可以<b>点击联系</b>进入博客看介绍哦"..
            "<p>2.）<b>配</b>置文件目录("..mulu..")<br><b>数据:</b>/data.json<br><b>脚本目录:</b>/diy/<br><b>预加载函数(如果开启):</b>/func.lua<br><b>测试员:</b>"..(this.getSharedData("admin") and {"TRUE"}or{"FLASE"})[1]);
            textSize="16dp";
            layout_width="-1";
          };
        },
        funs={false,
          function(d,v)
            d.hide()
            if v.Text=="联系我" then
              task(450,function()
                CD_L{t="联系我",funsl={
                    function(f)
                      --f.add{__type=1,title="当前主题:"..data["ui"]["theme"]["name"][data["ui"]["theme"]["id"]]}
                      for k,v in pairs({"应用市场","QQ临时会话","Github开源网页"}) do
                        --f.add{__type=6,subtitle="关于",message="包名:"..activity.getPackageName().."\n版本:0.1-(2019-3-2)",imagesrc="icon.png"}
                        f.add{__type=8,subtitle=k..":"..v}
                      end
                    end,
                    function(a,b,c)
                      switch(c)
                       case 0
                        --调用应用商店搜索应用
                        intent_url("market://details?id="..activity.getPackageName())
                       case 1
                        qq_lt("2358742797")
                       case 2
                        intent_url("https://github.com/alittlemc/org.alm.bug/")
                      end
                    end},c=false
                }
              end)
            end
          end
        }
      }
      --[[function()
         
          end
        end}]]
     case "执行代码"

      codedo("执行代码")

      --sr_edit1.getSelectionStart()
      --sr_edit1.setSelection(30)
    end
    List_Fun(val,id,v,zero,one)

    adp.notifyDataSetChanged()
    val=nil
  end
})

--功能函数
import {
  "lua.alm"
  --"lua.alert_dialog"
}

--print(luajava.coding("你好","UTF-8","HZ-GB-2312"))

--[[
luau=LuaUtil
local time0=os.clock()
--os.execute("ls -a "..mulu)
--shell("ls -a "..mulu)
print(LuaUtil.getFileMD5(mulu.."data.json"))
print("Os_time:"..os.clock()-time0.."s")

local time0=os.clock()
local md5 = require "codelua/md5"
print(md5.file(mulu.."data.json"))
print("Lua_time:"..os.clock()-time0.."s")
]]

--print(lfs.attributes(mulu.."function.lua"))
--[[
'是否存在：' + file.exists()); 
'文件名：' + file.getName()); 
'上级目录：' + file.getParent()); 
'是否可读：' + file.canRead()); 
'是否可写：' + file.canWrite()); 
'绝对路径：' + file.getAbsolutePath()); 
'相对路径：' + file.getPath()); 
'是否为绝对路径：' + file.isAbsolute()); 
'是否为目录：' + file.isDirectory()); 
'是否为文件：' + file.isFile())
'是否为隐藏文件：' + file.isHidden()); 
'最后修改时间：' + new Date(file.lastModified())); 
'文件长度：' + file.length());]]

--移动置顶事件
function CoordTop()
  ---{top}
  --load(data.ui.coord[1])()
end

--移动监听事件
function CoordProg(ss)
  ---{prog}
  --load(data.ui.coord[2])()
end

--自动置底事件
function CoordBottom()
  ---{bottom}
  --load(data.ui.coord[3])()
end

collectgarbage("collect")

appD=require "lua.download"

--({a=1,b=2,c=3}:Test())