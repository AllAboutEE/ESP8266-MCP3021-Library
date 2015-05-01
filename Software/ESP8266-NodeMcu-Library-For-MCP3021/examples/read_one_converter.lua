-- Reads and displays data from the MCP3021A3 every 1000 milli seconds (1 second)
-- You'll want to use a floating point firmware version or you'll only get integers for the voltage reading
-- MCP3021 Breakout Board: 

require ("mcp3021")

gpio0, gpio2 = 3, 4

mcp3021.setup(gpio2,gpio0,i2c.SLOW) -- use GPIO2 as SDA, use GPIO0 as SCL

-- Continously execute the function code every 1000 milli seconds (1 second)
tmr.alarm(0,1000,1,function()

    local digitalValue = mcp3021.read(3) -- read from MCP3021A3, 
                                         -- to read from another e.g. MCP3021A5, use 5 instead of 3

    -- convert to voltage value based on VDD = 3.3V
    local voltageValue = digitalValue*3.3/1024

    -- check if there were any errors while reading before printing
    if(digitalValue~=nil) then
        print("Digital Value: " .. digitalValue)
        print("Voltage Value: " .. voltageValue)
    else
        if(digitalValue == mcp3021.ERROR_NAK) then
            print("ERROR: Received NAK from address")
        else -- mcp3021.ERROR_MSB
            print("ERROR: Invalid MSB")
        end
    end
end)