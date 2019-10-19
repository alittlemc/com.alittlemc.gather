import "java.io.File"
if (fbool(mulu.."func.lua") and data.load.diy) then
  local val=cjson.decode(fr(mulu.."func.json"))
  ls=val.ls
  diyname=val.diyname
  diyname_about=val.diyname_about
  diyname_all=val.diyname_all
  dofile(mulu.."func.lua")
  

 else

  local ui_code,code_,bar_code=[[ui_do={PageView;id="pagev";layout_width="-1";layout_height="-1";]],"\n};\n",
  [[bar_0={PageView;id="pagev_bar";layout_width="-1";layout_height="-1";]]

  local funs={
    [[
--添加侧边栏布局
function List_Add()
  ---{list_ui}
]],

    [[
--侧边List点击事件setOnItemClickListener
function List_Fun(a,b,c,d,e)--text,id,v,zero,one
  ---{list_bar_case}
  switch(a)
]],

    [[
--main.lua文件底
function Alm_Main()
  ---{load_main}
]],

    [[
--build.lua文件底
function Alm_Build()
  ---{load_build}
]],

    [[
--控件小球点击事件
function Xfun_Fun(i)
  ---{xfun(i)_case}
  switch(i)
]],

    [[
--重载软件事件
function onResume_Func()
  ---{resume}
]],

    [[
--退出软件事件
function onDestroy_Func()
  ---{destroy}
]],

    [[
--改变方向事件事件
function onConfigurationChanged_Func(a)
  ---{changed(a)}
]],

    [[
--物理按键按下事件
function onKeyDown_Func(a,b)
  ---{keyDowm(a,b)}
]]}

  local find,sub,gsub,match,concat=string.find,string.sub,string.gsub,string.match,table.concat
  local arr_func={{""},{""},{""},{""},{""},{""},{""},{""},{""}}--9,#funcs同
  local arr_ui={{""},{""}}
  local d,k,p,defineT="NULL",0,"NULL",{}
  diyname,diyname_all,diyname_about={},{},{}
  --不存在/diy时解压缩自带的配置文件
  if not File(mulu.."diy").isDirectory() then
    LuaUtil.unZip(activity.getLuaDir().."/files/diy.zip",mulu.."diy")
  end
  --ls=luajava.astable(File(mulu.."diy").listFiles())
  ls=split(shell("ls "..mulu.."diy"),"\n")
  
  --[[for k,v in pairs(ls) do
    print(k,v)
  end]]

  for i=1,#ls-1,1 do
    ls[i]=mulu.."diy/"..ls[i]
    p=File(ls[i]).getName() or "命名丢失"
    if not File(ls[i]).isFile() and fbool(ls[i].."/main.diy") then
      d="Directory"
      ls[i]=ls[i].."/main.diy"
      p=p.."/"
     elseif File(ls[i]).isFile() and match(ls[i],"%.(.+)")=="diy" or match(ls[i],"%.(.+)")=="add" then
      d="File"
     else
      k=k+1
      continue
    end
    local class=fr(ls[i]) or ""
    define=match(string.format("%s",class),"{define}(.-){define}") or ""
    class=match(class,"{body}(.-){body}") or ""
    if class=="" then
      k=k+1
      continue
    end
    class=tableChange2(class,{"@path@",ls[i],"@id@",i-k,"@mod@",d,"@file@",p,"@k@",k,"#Directory#",mulu.."diy/"..p})--内部变量嵌入
    defineT=split(define,",")--使用split提为列表

    class=(defineT[#defineT] and {tableChange2(class,defineT)} or {tableChange1(class,defineT)})[1]
    table.insert(diyname_all,defineT[2] or "#命名丢失#")
    table.insert(diyname_about,defineT[4] or "#无简介#")
    class=split(class,"<alittlemc/>")
    class_ui=split(class[1],"<alittlemc/split>")
    if #class_ui[1]>=22 and #class_ui[2]>=22 then
      for j=1,2,1 do
        arr_ui[j][i-k]=class_ui[j] or ""
      end

      table.insert(diyname,defineT[2] or "#命名丢失#")
      
     else
      k=k+1
    end
    class_func=split(class[2],"<alittlemc/split>")
    for key,v in pairs(class_func) do
      arr_func[key][i-k+1]=v or ""
    end

    --[[
      内容组1={{第一个文件的内容组1},{第二个文件的内容组1}},
      内容组2={{第一个文件的内容组2},{第二个文件的内容组2}}
      ]]
    --合并第n个内容组arr_func[n])

  end
  local ui=concat({
    ui_code,
    "\npages={\n--{ui}",
    concat(arr_ui[1]),"\n};",
    code_,
    bar_code,
    "\npages={\n--{bar}",
    concat(arr_ui[2]),"\n};",
    code_})
  load(ui)()
  local func=""
  for key,v in pairs(funs) do
    func=concat({func,concat({v,concat(arr_func[key]),((key==2 or key==5)and {"\nend\nend\n"} or {"\nend\n"})[1]})})
  end
  --fw(activity.getLuaDir().."/test.lua",ui.."\n"..func)
  if data["load"]["diy"] then
    fw(mulu.."func.lua",ui.."\n"..func)
    fw(mulu.."func.json",cjson.encode({["diyname_all"]=diyname_all,["diyname_about"]=diyname_about,["diyname"]=diyname,["ls"]=ls}))
  end
  load(func)()
end
collectgarbage("collect")
--print(diyname)