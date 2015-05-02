-- This example serves a webpage and displays the sensor/converter value (almost) live / real-time 
-- The computer/device from which you visit the webpage MUST have internet connection since
-- Google hosted libraries are been used to draw the graphs and update the data

require ("mcp3021")

-- configure ESP as a station
wifi.setmode(wifi.STATION)
wifi.sta.config("xxx","xxxxxx+")
wifi.sta.autoconnect(1)

gpio0, gpio2 = 3, 4

mcp3021.setup(gpio2,gpio0,i2c.SLOW) -- use GPIO2 as SDA, use GPIO0 as SCL

local function display_webpage(socket,request)
  
   
   _, _, method, req, major, minor = string.find(request, "([A-Z]+) (.+) HTTP/(%d).(%d)");

   if(string.find(req,"/monitor.html")) then -- request made to sesnor page
      
     socket:send("HTTP/"..major.."."..minor.." 200 OK\r\nContent-Type: text/html\r\nConnection: close\r\n\r\n")
     socket:send("<html><head><style type=\"text/css\">")
     socket:send("html, body { background-color: transparent; text-align: center; margin: 0 auto;}")
     socket:send("#chart_div { width: 500px; text-align: center; margin: 0 auto;}</style></head>")
     
     socket:send("<body><div id='chart_div'></div>")
     -- include Jquery and graphing API
     socket:send("<script type='text/javascript' src='https://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js'></script>")
     socket:send("<script type='text/javascript' src='https://www.google.com/jsapi'></script>")
     -- ocde to handle graph/gauge and its updates
     socket:send("<script type='text/javascript'>")
     socket:send("var chart;var data;")
     socket:send("google.load('visualization', '1', {packages:['gauge']});\r\n")
     socket:send("google.setOnLoadCallback(initChart);\r\n")
     -- function that updates the graph
     socket:send("function displayData(point) {\r\n")
     socket:send("data.setValue(0, 0, 'Sensor');\r\n")
     socket:send("data.setValue(0, 1, point);\r\n")
     socket:send("chart.draw(data, options);}\r\n")
     -- function that grabs a new reading
     socket:send("function loadData() {var p;\r\n")
     socket:send("$.getJSON('http://"..wifi.sta.getip().."/data.json', function(data) {\r\n") 
     socket:send("p = data.sensor;")
     socket:send("if(p){displayData(p);}")
     socket:send("});}")
     -- function that creates a new chart
     socket:send("function initChart() {data = new google.visualization.DataTable();")
     socket:send("data.addColumn('string', 'Label');data.addColumn('number', 'Value');data.addRows(1);")
     socket:send("chart = new google.visualization.Gauge(document.getElementById('chart_div'));\r\n")
     socket:send("options = {width: 500, height: 500, redFrom: 90, redTo: 100,")
     socket:send("yellowFrom:75, yellowTo: 90, minorTicks: 5,max: 3.3};")
     -- call loadData once to create and grab data for the first time
     socket:send("loadData();")
     -- call loadData every second
     socket:send("setInterval(loadData, 1000);}</script></body></html>")

   elseif (string.find(req,"/data.json")) then -- request made to data.json page
     
     local sensor = mcp3021.read(3) -- read MCP3021A3
     -- convert to voltage vased on VDD = 3.3V
     local result = sensor*3.3/1024
     
     -- serve json
     socket:send("HTTP/"..major.."."..minor.." 200 OK\r\nContent-Type: application/json\r\nConnection: close\r\n\r\n"); 
     socket:send("{\"sensor\":\""..result.."\"}");
     
   end

    socket:close()
    socket = nil
   
end

-- check for a successful connection to the AP (when we obtain an IP address)
tmr.alarm(0,1000,1,function()
     local  ip, netmask, gateway = wifi.sta.getip()
     
     if(ip~=nil) then
          print("IP address obtained!")
          print("Visit \""..ip.."/monitor.html\"") -- print the IP address so you know which ip address to visit
          tmr.stop(0) -- stop the timer alarm
          -- we have an IP address so start server
          server = net.createServer(net.TCP)

          server:listen(80,function(socket)
              socket:on("receive",display_webpage)
          end)
     else
          print("Waiting to obtain IP address...")
     end
     
end)
