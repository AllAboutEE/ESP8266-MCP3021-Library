-- Reads and displays data from the MCP3021A3 every 1000 milli seconds (1 second)
-- You'll want to use a floating point firmware version or you'll only get integers for the voltage reading
-- MCP3021 Breakout Board: https://www.tindie.com/products/AllAboutEE/esp8266-analog-inputs-expander/

require ("mcp3021")

gpio0, gpio2 = 3, 4

mcp3021.setup(gpio2,gpio0,i2c.SLOW) -- use GPIO2 as SDA, use GPIO0 as SCL

-- Continously execute the function code every 1000 milli seconds (1 second)
tmr.alarm(0,1000,1,function()
    --  read MCP3021A0 to MCP3021A3
    local c0 = mcp3021.read(0)
    local c1 = mcp3021.read(1)
    local c2 = mcp3021.read(2)
    local c3 = mcp3021.read(3)

    -- Note: don't forget to check each conversion for errors,
    -- this step was skipped here to keep code simple/short. 
    -- See example "read_one_convert" for error checking if statement
    print("\r\nNew Readings")
    print("A0: "..c0)
    print("A1: "..c1)
    print("A2: "..c2)
    print("A3: "..c3)

end)