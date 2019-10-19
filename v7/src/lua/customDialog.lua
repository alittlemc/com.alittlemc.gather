-- 简化底部对话框
function BottomDialog(t)
  return CustomDialog.build()
  :setTitle(t.title or "标题")
  :setRadius(Color.WHITE,10,10)
  :setMessage(t.message or "内容")
  :setCancelable(t.cancelable or false)
  :addButton(t.button or {"关闭"},t.buttonColor)
  --:setGravity(Gravity.CENTER)
  --:setParams(true)
  --:enterAnimation()
  --:exitAnimation()
  :setOnClick(t.onClick)
  --:setOnLongClick(function(dialog,view)dialog.hide()end)
end


-- 简化居中对话框
function CenterDialog(t)
  local width = activity.getWidth()
  return CustomDialog.build()
  :enterAnimation(nil,0,10000,0,0)
  :exitAnimation(nil,0,0,0,0)
  :setTitle(t.title or "标题")
  :setRadius(Color.WHITE,10,10,10,10)
  :setMessage(t.message or "内容")
  :setCancelable(t.cancelable or false)
  :addButton(t.button or {"关闭"},t.buttonColor)
  :setGravity(Gravity.CENTER)
  :setParams(true,width-200)

  :setOnClick(t.onClick)
  --:setOnLongClick(function(dialog,view)dialog.hide()end)
end


function ClickEvent(view)
  switch(view.Text)
   case "底部对话框"
    BottomDialog{
      title="开源协议",
      message=LICENSE,
      cancelable=true,
      button={"关闭","知道了"},
      buttonColor={0xff359461},
      onClick=function(dialog,view)
        dialog.hide()
        switch(view.Text)

        end
      end
    }.show()

   case "居中对话框"
    CenterDialog{
      title="开源协议",
      message=LICENSE,
      cancelable=true,
      button={"关闭","知道了"},
      buttonColor={0xff359461},
      onClick=function(dialog,view)
        dialog.hide()

      end
    }.show()

   case "全屏对话框"
    local view = CustomDialog.build()
    :setTitle("开源协议")
    :addView({
      TextView,
      text=LICENSE,
      padding="32dp";
    })
    :addButton({"关闭"},{0xff359461})
    :setRadius(Color.WHITE)
    :setParams(true,MATCH_PARENT,MATCH_PARENT)
    .show()

  end
end

--[[CenterDialog{
  title="开源协议",
  message=LICENSE,
  cancelable=true,
  button={"关闭","知道了","知道"},
  buttonColor={0xff359461},
  onClick=function(dialog,view)
    dialog.hide()

  end
}.show()]]

--case "全屏对话框"
function CD(t,lay,f)
  local v=CustomDialog.build()
  if t[1] then
    v:setTitle(Html.fromHtml(t[1]))
  end
  if type(lay)=="table" then
    v:addView(lay)
   else
    v:setMessage(Html.fromHtml(lay))
  end
  if f[1] then
    f[1]()
  end
  v:addButton({t[2],t[3],t[4]},{color1,color1,color3})
  :setRadius(Color.WHITE)
  :setParams(true,MATCH_PARENT,MATCH_PARENT)
  :setOnClick(function(d,v)
    switch(v.Text)
     case t[2]
      if f[2] then
        f[2]()
      end
     case t[3]
      if f[3] then
        f[3]()
      end
     case t[3]
      if f[3] then
        f[3]()
      end
    end
  end)
  .show()
end

--CD({"标题","1","2","3"},"hi，<font color='red'>你好</font>哈",{})
--print(LICENSE)

--[[bin=require "codelua/bin"

str=bin.stohex("你好",2)

a={v="\\u"..str:gsub("\n","\\u")}
d=json.encode(a)]]
import "javaalm"
fw(mulu.."test.java",javaalm.getCharInt("你好",2,true).."="..javaalm.getIntChar(288))
--[[val=require "tox_d"

v1=val.rtor("10",10,72)
v2=val.rtor(v1,72,16)

print(v1,v2)]]
--r1:false,text:type_integer
--r2:false,text:type,string