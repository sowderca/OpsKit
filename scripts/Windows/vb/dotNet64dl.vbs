option explicit

dim oXMLHTTP
dim oStream

set oXMLHTTP = CreateObject("MSXML2.XMLHTTP.3.0")

oXMLHTTP.Open "GET", "http://download.microsoft.com/download/9/8/6/98610406-c2b7-45a4-bdc3-9db1b1c5f7e2/NetFx20SP1_x64.exe", false
oXMLHTTP.Send

if oXMLHTTP.Status = 200 then
	set oStream = CreateObject("ADODB.Stream")
	oStream.Open
	oStream.Type = 1
	oStream.Write oXMLHTTP.responseBody
	oStream.SaveToFile "C:\NetFx20SP1_x64.exe"
	oStream.Close
end if
