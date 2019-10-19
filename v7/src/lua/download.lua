local function fun(url,path,f,...)
  require "import"
  import "java.net.URL"
  import "java.io.File"
  file=File(path)
  local con=URL(url).openConnection()
  local co=con.getContentLength()
  local is=con.getInputStream()
  local bs=byte[1024]
  local len,read=0,0
  import "java.io.FileOutputStream"
  local wj=FileOutputStream(path)
  len=is.read(bs)

  while len~=-1 do
    wj.write(bs,0,len)
    read=read+len
    len=is.read(bs)
  end

  wj.close()
  is.close()
  if f then
    f({...} or false)
  end
end

function appDownload(url,path,f,...)
  thread(fun,url,path,f,...)
end

return appDownload
