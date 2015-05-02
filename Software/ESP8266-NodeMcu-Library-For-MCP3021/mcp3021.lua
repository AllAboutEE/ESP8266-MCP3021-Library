---
-- @date April 03, 2015
--
-- @description A module/library for the MCP3021,
-- an I2C 10-bit A/D converter with a pre-programmed address of 0b1001000 to 0b1001111.
--
-- @datasheet http://ww1.microchip.com/downloads/en/DeviceDoc/21805B.pdf
--
-- @author Miguel 
--  GitHub: https://github.com/AllAboutEE 
--  YouTube: https://www.youtube.com/user/AllAboutEE
--  Website: http://AllAboutEE.com
--
-- MCP3021 Breakout Board: 
--------------------------------------------------------------------------------------------
local moduleName = ... 
local M = {}
_G[moduleName] = M 

    local id = 0

    local MCP3021_I2C_ADDRESS = 0x48 -- device bits

    M.ERROR_NAK = -1
    M.ERROR_MSB = -2

    ---
    -- @name M.read
    --
    -- @param addressBits The last three bits in the device's I2C address:
    -- There are 8 versions of the MCP3021 (MCP3021A0 to MCP3021A7)
    -- e.g. For MCP3021A5 the addressBits wouldb be 5, 
    -- for MCP3021A0 the addressBits would be 0
    --
    -- @brief Reads 10-bit value from the A/D converter
    --
    -- @returns Digital value between 0 and 1023
    ---------------------------------------------------------------------------------------------
    function M.read(addressBits)
        local address = bit.bor(addressBits,MCP3021_I2C_ADDRESS) -- MCP3021 devices have addresses 0b1001xxx 
                                                                 -- where the 4 MSB are fixed and the 3 LSB vary from 0b000 to 0b111
                                                                 -- for MCP3021A0 and MCP3021A7 respectively
        i2c.start(id)
        -- Read the data form the register
        if(i2c.address(id,address,i2c.RECEIVER)~=false) then -- send the MCP's address and read bit
          
            local data = i2c.read(id,2)
         
            i2c.stop(id)

            local msb, lsb = string.byte(data,1,2)

            if(msb <= 0x0f) then -- msb is [0] [0] [0] [0] [D9][D8][D7][D6] so it can't be larger than 0x0f

                -- We want to make the result be [D9][D8][D7][D6][D5][D4][D3][D2][D1][D0]
               
                lsb = bit.band(bit.rshift(lsb,2),0x3f)  -- lsb is [D5][D4][D3][D2][D1][D0][x] [x] so we right shift 2 times and clear the unecessary bits

                -- msb is [0] [0] [0] [0] [D9][D8][D7][D6] so we left shift 6 times
                local result = bit.lshift(msb,6)+lsb -- then we add msb and lsb to get the 10-bit reading

                return result
            else
                return M.ERROR_MSB
            end

        else
            i2c.stop(id)
            return M.ERROR_NAK -- received NAK from address
        end

    end

    -- @name setup
    -- @brief sets up the I2C module
    ---------------------------------------------------------------------------------
    function M.setup(pinSDA,pinSCL,speed)
     i2c.setup(id,pinSDA,pinSCL,speed)
    end

return M