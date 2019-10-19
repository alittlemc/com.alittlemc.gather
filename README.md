# com.alittlemc.gather
## 作者:alittlemc

## 打包:
* 使用Android手机,安装对应软件打包(`推荐`):
    * ALuaj
        * 将工程文件夹**V7\**移动**..\ALuaj\Project\**目录下
        * 推荐,请注意**gen**文件夹中**R.java**的主题地址要与**src\mian.lua**中**data**数组**theme项目中的**nbt**对应,原工程中为*0x7f060001*
    * AndroLua+
        * 将工程文件夹**V7\src\**移动**..AndroLua\project\**目录下
        * 此方法主题色将无法生效!因为**V7\res\values\styles.xml**不生效
## 第三方开源:
* NumConvert.lua
    * 任意进制转换,在原来基础追加方法rtor,并且提升为93进制,还可以可扩充
    
``` lua
    
tox=require "openSource.NumConvert.main"
tox.rtor("abc",93,40)-->将93进制的abc转为40进制,并且返回
tox.rtox("abc",40)-->将93进制的abc转为10进制,并且返回
tox.xtor(1024,40)-->将10进制的1024转为40进制,并且返回
    
tox.length-->返回最高位进制,93,可扩充
tox.getChar("%")-->返回%对应的进制数
```

* CenterDialog.lua
    * 开源的Dialog(luajava)
    * 已经魔改,请不要直接使用,如果需要请结合我编写的**link\CD.lua**使用

``` lua

CenterDialog=require "openSource.CustomDialog.main"
具体可以移步我的博客查看

CD{
    t="标题",
    aly={--可以是lua布局也可以是文字},
    b={"按钮"},--最多三个
    funs={function(d)print("载入事件")end,function(d,v)print(v.Text.."按钮点击事件")end,function(d,v)print(v.Text.."按钮长按事件")end}
    mod=1,--可以输入1,2,3或者{长,宽,true/false}
}--等

具体
CD_L--列表
CD_T--通知
请看源代码

常驻变量cd
cd.hide()
```
    
