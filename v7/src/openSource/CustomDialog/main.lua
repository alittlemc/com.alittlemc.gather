import {
  "android.app.Dialog",

  "android.content.res.ColorStateList",

  "android.graphics.Color",
  "android.graphics.Typeface",
  "android.graphics.drawable.GradientDrawable",

  "android.widget.TextView",
  "android.widget.CardView",
  "android.widget.ScrollView",
  "android.widget.LinearLayout",
  "android.widget.RelativeLayout",

  "android.view.KeyEvent",
  "android.view.Gravity",
  "android.view.ViewGroup",
  "android.view.MotionEvent",
  "android.view.WindowManager",
  "android.view.animation.TranslateAnimation",
  "android.view.animation.Animation$AnimationListener",
}


--全局变量

--[[SCREEN_WIDTH = activity.getWidth()--wh
SCREEN_HEIGHT = activity.getHeight()]]--hh
WRAP_CONTENT = ViewGroup.LayoutParams.WRAP_CONTENT
MATCH_PARENT = ViewGroup.LayoutParams.MATCH_PARENT


--私有变量
local FONT_BOLD = Typeface.defaultFromStyle(Typeface.BOLD)
local mCustomDialog, mContentView, mDialogObject, mWindow = {}
local MAIN_COLOR = color3--activity.getSharedData("MAIN_COLOR") or 0xFF009688;
local DARK_COLOR = color3-40--activity.getSharedData("DARK_COLOR") or 0xFF00796B;
local LIGTH_COLOR = color3+40--activity.getSharedData("LIGTH_COLOR") or 0xFF64FFDA;
local mTheme, mDialog = android.R.style.Theme_Material_Light_NoActionBar, Dialog
local DURATION = 450--activity.getResources().getInteger(android.R.integer.config_mediumAnimTime)


--私有函数
local function RippleDrawable(color)
  local Borderless = android.R.attr.selectableItemBackgroundBorderless
  local StyledAttributes = activity.obtainStyledAttributes({Borderless})
  local Ripple = StyledAttributes.getResourceId(0, Borderless);
  StyledAttributes.recycle();
  return activity.getDrawable(Ripple).setColor(ColorStateList(int[0].class{int{}},int{color}))
end


--添加元方法&设置元表(继承)
CustomDialog = {button = {}}
CustomDialog.__index=CustomDialog
setmetatable(mCustomDialog,CustomDialog)


--构建自定义对话框
function CustomDialog:build(theme)
  local contentView = LinearLayout(this)
  .setOrientation(LinearLayout.VERTICAL)

  local dialog = mDialog(this,theme or mTheme)

  .setCancelable(true)
  .setContentView(contentView)
  .setCanceledOnTouchOutside(true)

  mWindow = dialog.getWindow()
  mWindow.setGravity(Gravity.BOTTOM)
  local params = mWindow.getAttributes();
  params.width = width or MATCH_PARENT;
  params.height = height or WRAP_CONTENT;

  mWindow.setAttributes(params)
  .setWindowAnimations(theme or mTheme)
  .addFlags(WindowManager.LayoutParams.FLAG_DIM_BEHIND)
  .setBackgroundDrawableResource(android.R.color.transparent)
  .setFlags(WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL,WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL)
  .addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS).setNavigationBarColor(Color.TRANSPARENT)
  .setFlags(WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH,WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH)
  .dimAmount = 0.4

  dialog.setOnKeyListener({
    onKey=function(dialog, code)
      switch(code)
       case KeyEvent.KEYCODE_BACK
        mCustomDialog:hide()
        return true
      end
    end
  })

  mWindow.getDecorView().onTouch=function(v, event)
    switch(event.getAction())
     case MotionEvent.ACTION_OUTSIDE
      mCustomDialog:hide()
      return true;
    end
  end

  mCustomDialog.dialogObject = dialog
  mCustomDialog.contentView = contentView
  mContentView = mCustomDialog.contentView
  mDialogObject = mCustomDialog.dialogObject

  return mCustomDialog
end


--设置是否能关闭
function CustomDialog:setCancelable(bool)
  local dialog = mDialogObject

  mWindow.getDecorView()
  .setOnTouchListener({
    onTouch=function(view, event)
      switch(event.getAction())
       case MotionEvent.ACTION_OUTSIDE
        if bool then
          mCustomDialog:hide()
        end
        return true;
      end
    end
  })

  dialog.setOnKeyListener({
    onKey=function(dialog, code)
      switch(code)
       case KeyEvent.KEYCODE_BACK
        if bool then
          mCustomDialog:hide()
        end
        return true
      end
    end
  });

  return mCustomDialog
end


--[[设置标题
function CustomDialog:setTitle(title)
  local content = mContentView
  content.addView(loadlayout{
    TextView;
    textSize="20sp";
    text=Html.fromHtml(title) or "";
    paddingTop="12dp";
    Typeface=FONT_BOLD;
    paddingLeft="16dp";
    paddingRight="16dp";
    layout_width="fill";
    textColor=MAIN_COLOR;
  },content.getChildCount())

  return mCustomDialog
end]]

function CustomDialog:setTitle(title)
  local content = mContentView
  content.addView(loadlayout{
    RelativeLayout;
    layout_width="-1";
    {
      TextView;
      textSize="20dp";
      paddingLeft="16dp";
      paddingTop="12dp";
      layout_width="80%w";
      paddingRight="16dp";
      text=Html.fromHtml(title) or "";
      Typeface=FONT_BOLD;
      textColor=MAIN_COLOR;
    };
    {
      TextView;
      textSize="20dp";
      paddingLeft="16dp";
      paddingTop="12dp";
      layout_alignParentEnd="true";
      --layout_width="-2";
      paddingRight="16dp";
      text="×";
      id="x";
      onClick=function() mCustomDialog.hide() end;
    };
  },content.getChildCount())
  --RippleHelper(x).RippleColor=color1
  return mCustomDialog
end

--添加控件
function CustomDialog:setMessage(message)
  local content = mContentView
  content.addView(loadlayout{
    ScrollView,
    layout_width="fill";
    layout_height="-2";--SCREEN_HEIGHT/2,
    {
      TextView,
      --padding="16dp";
      paddingRight="16dp";
      paddingLeft="16dp";
      --paddingButtom="16dp";
      layout_width="fill";
      textSize="17dp";
    },
  },content.getChildCount())
  .getChildAt(content.getChildCount()-1)
  .getChildAt(0).Text = Html.fromHtml(message)
  return mCustomDialog
end


--添加控件
function CustomDialog:addView(view)
  local content = mContentView
  local count = content.getChildCount()

  switch(type(view))
   case "table"
    mCustomDialog.view = content.addView(loadlayout(view)).getChildAt(count)

   default
    mCustomDialog.view = content.addView(view).getChildAt(count)
  end
  return mCustomDialog
end


--设置视图内容
function CustomDialog:setContentView(view)
  local content = mContentView
  mContentView.removeAllViews()
  local count = content.getChildCount()

  switch(type(view))
   case "table"
    mCustomDialog.view = content.addView(loadlayout(view)).getChildAt(count)

   default
    mCustomDialog.view = content.addView(view).getChildAt(count)
  end
  return mCustomDialog
end


--对话框按钮
function CustomDialog:addButton(buttons,color)
  local content = mContentView
  content.addView(loadlayout{
    RelativeLayout;
    gravity="center",
    paddingTop="10dp";
    layout_width="fill";
    layout_height="wrap";
    paddingBottom="10dp";
  },content.getChildCount())

  local function addbutton(text,color)
    local buttonView = loadlayout{
      LinearLayout;
      layout_width="100dp";
      layout_height="36dp";
      {
        CardView;
        Elevation=0;
        layout_width="fill";
        layout_height="fill";
        BackgroundColor=color;
        layout_marginLeft="16dp";
        layout_marginRight="16dp";
        {
          TextView;
          text=text,
          textSize="16dp";
          gravity="center";
          Typeface=FONT_BOLD;
          layout_width="fill";
          layout_height="fill";
          textColor=Color.WHITE;
          Background=RippleDrawable(0x1CFFFFFF);
          OnClickListener=function(view)mCustomDialog:hide()return true end,
          OnLongClickListener=function(view)--[[print(view.Text)]]return true end,
        },
      },
    }
    return buttonView
  end

  --默认按钮颜色
  local dColor = {
    LIGTH_COLOR,
    MAIN_COLOR,
    DARK_COLOR
  }

  local mColor = dColor
  local count = content.getChildCount()-1
  local view = content.getChildAt(count)

  for int, text in ipairs(buttons) do
    view.addView(loadlayout{
      LinearLayout;
      gravity="right",
      layout_width="fill";
      layout_height="wrap";
    })

    if int <= 3 then
      local mColor = mColor[int] or dColor[int]
      local buttonView = addbutton(text,mColor)
      local mCardView = buttonView.getChildAt(0)

      if int == 1 then
        switch(#buttons)
         case 3
          view.addView(buttonView)
         case 2
          view.getChildAt(0).addView(buttonView)
         case 1
          view.getChildAt(0).addView(buttonView)
         default
          view.addView(buttonView)
        end
        mCustomDialog.button[int] = mCardView.getChildAt(0)
      end

      if int > 1 and int <= 3 then
        view.getChildAt(0).addView(buttonView)
        mCustomDialog.button[int] = mCardView.getChildAt(0)
      end

    end

  end

  return mCustomDialog
end


--按钮点击事件
function CustomDialog:setOnClick(event)
  for int, button in ipairs(mCustomDialog.button) do
    button.OnClickListener=function(view)
      event(mCustomDialog,view)
      switch(#mCustomDialog.button)
       case 1
        mCustomDialog:hide()
       default
        if view.Text == "关闭" then
          mCustomDialog:hide()
        end
      end
      return true
    end
  end
  return mCustomDialog
end


--按钮长按事件
function CustomDialog:setOnLongClick(event)
  for int, button in ipairs(mCustomDialog.button) do
    button.OnLongClickListener=function(view)
      event(mCustomDialog,view)
      return true
    end
  end
  return mCustomDialog
end


--开始动画
function CustomDialog:enterAnimation(anima, fromX, toX, fromY, toY)
  local dialog = mDialogObject.show()
  local animation = anima or TranslateAnimation(fromX or 0, toX or 0, fromY or hh, toY or 0)
  if animation then
    animation.setDuration(DURATION).setFillAfter(true)
  end
  return mCustomDialog, animation
end


--结束动画
function CustomDialog:exitAnimation(anima,fromX, toX, fromY, toY)
  local dialog = mDialogObject
  local animation = anima or TranslateAnimation(fromX or 0, toX or 0, fromY or 0, toY or hh)
  if animation then
    animation.setDuration(DURATION)
    .setFillAfter(true)
    .setAnimationListener(AnimationListener{
      onAnimationStart=function()
        mWindow.dimAmount = 0
      end,
      onAnimationEnd=function()
        dialog.dismiss()
      end
    })
  end
  return mCustomDialog, animation
end

--显示对话框
function CustomDialog:show()
  local dialog = mDialogObject
  local content = mContentView
  local _, animation = mCustomDialog:enterAnimation()
  content.startAnimation(animation)
  return mCustomDialog
end


--关闭对话框
function CustomDialog:hide()
  local dialog = mDialogObject
  local content = mContentView
  local _, animation = mCustomDialog:exitAnimation()
  content.startAnimation(animation)
  --本地化
  if cd then
    cd=false
  end
  return mCustomDialog
end


--设置对齐方式
function CustomDialog:setGravity(gravity)
  mWindow.setGravity(gravity or Gravity.BOTTOM)
  return mCustomDialog
end


--设置宽高
function CustomDialog:setParams(boolean,width,height)
  if boolean then
    mWindow.addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS |
    WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)
    .setNavigationBarColor(Color.TRANSPARENT)
  end

  local params = mWindow.getAttributes();
  params.width = width or MATCH_PARENT;
  params.height = height or WRAP_CONTENT;
  mWindow.setAttributes(params)
  return mCustomDialog
end


--设置背景颜色&圆角大小
function CustomDialog:setRadius(color,leftTop,rightTop,rightBottom,leftBottom)
  local leftTop = leftTop or 0
  local rightTop = rightTop or 0
  local leftBottom = leftBottom or 0
  local rightBottom = rightBottom or 0
  local cornerRadii = {
    leftTop,leftTop,
    rightTop,rightTop,
    rightBottom,rightBottom,
    leftBottom,leftBottom
  }

  local gradientDrawable = GradientDrawable()
  .setCornerRadii(cornerRadii)
  .setColor(color or Color.TRANSPARENT)
  .setShape(GradientDrawable.RECTANGLE)
  mContentView.setBackgroundDrawable(gradientDrawable)
  return mCustomDialog
end

return CenterDialog