CenterDialog=require "openSource.CustomDialog.main"

local function CD_re(t)
  if cd then
    cd.hide()
    local v=os.date("%s")
  end

  cd=CustomDialog.build()
  switch(t.mod)
   case 1
    cd:setGravity(Gravity.CENTER)
    :setParams(true,wh-200)
   case 2
    cd:setParams(true,wh,hh+hsn/4)--,MATCH_PARENT,MATCH_PARENT)
   default
    if type(t.mod)=="table" then
      cd:setParams(t.mod[1],t.mod[2],t.mod[3])
    end
  end
  if t.g then
    switch(t.g)
     case 1
      cd:setGravity(Gravity.TOP)
     case 2
      cd:setGravity(Gravity.CENTER)
     case 3
      cd:setGravity(Gravity.BOTTOM)
    end
  end
  if t.t then
    cd:setTitle(t.t)
  end

  if type(t.aly)=="string" then
    cd:setMessage(t.aly)
   else
    cd:addView(t.aly)
  end
  cd:setRadius(theme_l_int,10,10,10,10)

  --cd:setRadius(theme_l_int)

  :setCancelable(t.c or false)
  if t.b then
    cd:addButton(t.b or {"关闭"})
  end
  --:setGravity(Gravity.CENTER)
  --:setParams(true)
  if t.a then
    if t.a==1 then
      cd:enterAnimation(nil,0,0,0,hh)
      :exitAnimation(nil,0,0,hh,0)
     elseif t.a==2 then
      cd:enterAnimation(nil,0,0,hh,0)
      :exitAnimation(nil,0,0,0,hh)
    end
  end
  if t.funs then
    if t.funs[2] then
      cd:setOnClick(t.funs[2])
    end
    if t.funs[3] then
      cd:setOnLongClick(t.funs[3])
    end
    if t.funs[1] then
      t.funs[1](cd)
    end
  end
  return cd
  --:setOnLongClick(function(dialog,view)dialog.hide()end)
end

function CD(t)
  if cd then
    cd.hide()
    cd=nil
    task(10+activity.getResources().getInteger(android.R.integer.config_mediumAnimTime),
    function()
      CD_re(t).show()
    end)
   else
    CD_re(t).show()
  end
end

--CD_L继承于CD
function CD_L(l)
  CD{
    t=l.t,
    mod=l.mod,
    b=l.b,
    c=l.c,
    aly={
      LinearLayout;
      orientation="vertical";
      layout_height="-1";
      layout_width="-1";
      {
        ListView;
        id="listview";
        dividerHeight="0";
        VerticalScrollBarEnabled=false;
        --layout_height="-1";
        layout_width="-1";
      };

    },
    funs={
      function(d)
        local cddat={}
        cdadp=LuaMultiAdapter(this,cddat,setting)
        if l.funsl[1] then
          l.funsl[1](cdadp)
        end
        listview.setAdapter(cdadp)

        if l.funs and l.funs[1] then
          l.funs[1](d)
        end

        listview.setOnItemClickListener(AdapterView.OnItemClickListener{
          onItemClick=function(id,v,zero,one)
            alm=v.Tag.subtitle.Text
            --print(cddat)
            --print(cddat[one].status["Checked"]==true)
            if l.funsl[2] then

              l.funsl[2](alm,v,zero,cdadp,cddat,one)

              task(100,function()
                cdadp.notifyDataSetChanged()
              end)

            end
          end})

      end,
      function(d,v)
        if l.funs and l.funs[2] then
          l.funs[2](d,v)
        end
      end,
      function(d,v)
        if l.funs and l.funs[3] then
          l.funs[3](d,v)
        end
      end
    },
  }
end

--弃

function CD_T(t)
  return CD{
    aly=(t.aly and t.aly.."<br>" or ""),t=t.t or "通知",b=t.b,
    c=t.c or true,r={0,0,0,0},funs={function(d)
        task(t.time or 5000,d,function(d)d.hide()end)
      end},mod=t.mod,g=t.g}
end
--[[
CD_T{t="好的"}.show()

task(1000,function()
  CD_T{t="好的"}.show()
  end)
]]
function clear()
  tab={}
  CD_L{t="重置与清理",mod=1,c=false,b={"清除","取消"},funs={false,
      function(d,v)
        local tab_m={"data.json","funs.lua","diy"}--,"本程序"}
        if v.Text=="清除" then
          if tab then
            if tab[1] then
              val=true
              data=nil
              fd(mulu.."data.json")
            end
            if tab[2] then
              val=true
              fd(mulu.."funs.lua")
            end
            if tab[3] then
              val=true
              fod(mulu.."diy")
            end
            if tab[4] then
              val=true
              del_app(activity.getPackageName())
            end
            if #tab>0 then
              close()
            end
          end
        end
        d.hide()
        tab=nil
      end},funsl={
      function(f)
        f.add{__type=1,title="选择清理项"}
        local t={"程序数据,绝大部分变量等数据都存放在此,清除可以实现重置程序","预加载脚本文件,内容来自diy目录提取,当你开启预加载功能,清除可以更新加载","diy目录,里面存放程序界面/功能的全部脚本,谨慎使用","卸载程序,如果有什么疑问可以联系作者哦,放我一马嘛(。-ω-)z"}
        for k,v in pairs({"/data.json","/funs.lua","/diy/(危险操作)","本程序"}) do
          --f.add{__type=6,subtitle="关于",message="包名:"..activity.getPackageName().."\n版本:0.1-(2019-3-2)",imagesrc="icon.png"}
          f.add{__type=9,subtitle=k..":"..v,message=t[k],status={Checked=Boolean.valueOf(false)}}
        end
      end,
      function(t,v,o,f,cddat,one)
        tab[one-1]=not (tab[one-1] or false)
        if v.Tag.status.Checked then
          cddat[one].status["Checked"]=false
         else
          cddat[one].status["Checked"]=true
        end
      end}
  }
end

function codedo(t,h)
  CD{mod={true,wh},
    t=t or "测试",
    aly={LinearLayout;
      layout_height="-1";
      padding="10dp";
      orientation="vertical";
      layout_width="-1";
      {LuaEditor;
        layout_width="-1";
        id="et";
        text=h or "--请输入需要测试的代码\n";
        layout_height="75%h",--"70%h";
        --hint="在此输入代码";
      };
    },
    --g=1,
    c=false,
    b={"运行","关闭"},

    funs={function(d)

      end,
      function(d,v)
        switch(v.Text)
         case "运行"
          load(et.Text)()
        end
      end}
  }
end

function codedo_err()
  codedo("错误","--事件触发器检测到"..str.."\n--尝试运行\nfod("..mulu.."diy/) cd.hide()\n将会清除全部的diy文件,请")
end

--print(activity.getTimeStamp())
function loading(t,l)
  CD{t=t or "正在加载",mod=1,aly={
      LinearLayout;
      layout_width="-1";
      --layout_height="50dp";
      orientation="horizontal";
      gravity="center";
      padding="20dp";
      {ProgressBar;
      };
      {TextView;
        text=l or "正在加载...";
        textSize="16dp";
        id="ProgressText";
      };
    }}
end