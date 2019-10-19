local mPath=mulu.."diy/ningStars/list/"
local mObjectLd,dObjectLd="675b5929f9","8D0gZZZ3"
local bmob_n=bmob("24196332bdcaa40d12f2791eeba75bed","c7c4bd4b210d96bdbf6512187432bf7a")

stars={stars=0}

function stars.set()
  stars.en()
  --bmob_n:insert("ningStars",{stars=-1,about=os.date("%j").." set"},function(a,b)end)
  bmob_n:update("ningStars",mObjectLd,{stars=stars.stars},function(a,b)
  end)
end

function stars.add(i,str)
  stars.en()
  local i_=i<0 and ""..i or "+"..i
  fw_a(mPath.."record.lua",os.date("%m-%d %H:%M:%S: ")..str.." # "..i_.." ⭐️\n")
  if stars.stars then
    stars.stars=stars.stars+i
    --bmob_n:increment("ningStars",mObjectLd,"stars",i,function(a,b)end)
    --bmob_n:insert("ningStars",{stars=-1,about=i_,text=str},function(a,b)end)
    --stars.init()
    fw(mPath.."stars"..os.date('%j')..".json",cjson.encode({stars=stars.stars}))
    if tointeger(os.date("%H%M"))>=2000then
      stars.set()
    end
  end
end

function stars.ran(i)
  return (i>=10 and{i-i*math.random(0,(i>=40 and{(i>=100 and{190}or{200})[1]}or{230})[1])//100}or{0})[1]-i*0.1
end

function stars.llq()
  stars.en()
  CD{c=false,mod=2,b={"关闭","<-","->"},funs={function()
        if stars.stars>0 then
          ningWeb.setWebViewClient{
            onPageFinished=function(view,url)
              --网页加载完成
              fw_a(mPath.."web.lua",os.date("%m-%d %H:%M:%S,")..ningWeb.getTitle()..","..url.."\n")
            end}
          ningWeb.loadUrl("http://cn.bing.com/").getSettings().setJavaScriptEnabled(true)
          ning_t=timer(function(fun,i,s)
            fun(i,s)
          end,1,180000,stars.add,-1,"使用浏览器三分钟")
         else
          --CD{t="没有星星了",mod=1,aly="你现在有"..stars.stars.."⭐️",b={"关闭"}}
        end
      end,function(d,v)
        switch(v.Text)
         case '关闭'
          ning_t.stop()
          ningWeb.stopLoading()
          cd.hide()
         case '<-'
          ningWeb.goBack()
         case '->'
          ningWeb.goForward()
        end
      end},aly={LuaWebView;
      layout_height="93%h";
      layout_width="-1";
      id="ningWeb";
    }}
end

function stars.lx()
  stars.en()
  CD{t="联系",aly={
      LinearLayout;
      orientation="vertical";
      layout_width="-1";
      {EditText;
        text="";
        hint="需要说些什么呢?";
        layout_marginTop="0dp";
        layout_width="-1";
        layout_gravity="center",
        layout_marginRight="16dp";
        layout_marginLeft="16dp";
        id="edit";
      };
    },b={"发送","关闭"},mod=1,funs={false,function(d,v)
        switch(v.Text)
         case "发送"
          stars.add(-1,"联系")
          bmob_n:insert("ningStars",{stars=-2,about="联系",text=tostring(edit.Text)},function(a,b)
            cd.hide()
          end)
        end
        cd.hide()
      end}}
end

function stars.jl()
  stars.en()
  loading("正在获取奖励")
  bmob_n:query("ningStars","MX51JJJR",function(a,b)
    if b.stars then
      CD{t="奖励",aly="原因:"..b.text.."\n奖励:"..b.stars,b={"关闭"},mod=1}
      stars.add(b.stars,b.text)
      if b.stars~=0 then
        bmob_n:update("ningStars","MX51JJJR",{stars=0,text="已经领取过了"},function(a,b)end)
      end
     else
      CD_T{t="出错 err:"..(a or "null"),time=200000,aly=cjson.encode(b)}
    end
  end)
end

function stars.en()
  if not stars.stars then
    print("无法获取星星,强制退出")
    activity.finish()
  end
end

function stars.init()
  if not fbool(mPath.."stars"..os.date("%j")..".json") then
    if fbool(mPath.."web.lua") then
      print("正在进行")
      fremove(mPath.."web.lua",mulu.."diy/ningStars/data/"..tointeger(os.date("%j")-1).."web.lua")
    end
    loading("正在签到")
    bmob_n:insert("ningStars",{stars=-1,about=os.date("%j").." 签到"},function(a,b)end)
    local i=tointeger(os.date("%H"))
    local r=(i==6 and {math.random(10,20)} or {2})[1]
    bmob_n:query("ningStars",mObjectLd,function(a,b)

      --setJqb(cjson.encode(b))
      fod(mPath)
      stars.en()

      stars.stars=b.stars
      CD{t="签到获得星星",aly=(stars.stars or -999).."+"..r,b={"关闭"}}
      stars.add(r,os.date("%j").."签到")
      fw(mPath.."stars"..os.date("%j")..".json",cjson.encode({stars=stars.stars}))
    end)
   else

    stars.stars=cjson.decode(fr(mPath.."stars"..os.date("%j")..".json")).stars or false
    if not stars.stars then
      fod(mPath)
    end
  end
end

stars.init()