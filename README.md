# ESP8266 Analog Input Expander Library for MCP3021 A/D Conveters

## **What is it?**
A board with four analog to digital (A/D) converters that your ESP8266 can interface with it using I2C.

## **Why did you make it?**
The ESP8266 is great module, but it lacks some functionality that it's often necessary to use another microcontroller to accomplish what you want. One of the features that it lacks are A/D converters (it only has one and it's hard to access if you have the ESP-01 version).

This board solves this problem by giving your ESP8266 module access to 4 analog to digital converters (analog inputs) via I2C.

## **What's Included?**

- board with 4 MCP3021 A/D converters. 
- 8 pin male header (not soldered)

**Note:** ESP8266 NOT included.

## **Software:**

We developed some Open Source, easy to use, libraries and examples so you can get started quickly.

- [Arduino for ESP8266 Library and Examples](https://github.com/AllAboutEE/ESP8266-MCP3021-Library/tree/master/Software/ESP8266-Arduino-Library-For-MCP3021) - Yes, you can run Arduino sketches on the ESP8266 alone without an Arduino.
- [NodeMcu Module/Library and Examples](https://github.com/AllAboutEE/ESP8266-MCP3021-Library/tree/master/Software/ESP8266-NodeMcu-Library-For-MCP3021) - For those who like to program in Lua

**Note:** For NodeMCU you'll need to [burn the firmware nodemcu float](https://www.youtube.com/watch?v=Gh_pgqjfeQc) if you want to read floating values e.g. 0.56V, 1.35V, 2.8566V  . If burn nodemcu integer instead then you'll only be able to read integers e.g. 1, 2, and 3 which is very likely not what you want.

## **Hardware:**

### **Converter Specs:**

- 4 Microchip MCP3021 A/D converters
- I2C interface
- 10-bit resolution
- Single supply specified operation: 2.7V to 5.5V

See the [MCP3021 A/D converter datasheet](http://ww1.microchip.com/downloads/en/DeviceDoc/21805B.pdf) for more details on each converter.


**Note:** If you are going to use this board with an ESP8266 you will need to power it with 3.3V and the analog inputs can only accept 0V to 3.3V. If you want to read voltage levels greater than 3.3V you'll have to add logic level converters at SCL and SDA.

### **Pinout:**


- VDD - 2.7V to 5.5V (Note: If using with ESP8266 you'll have to use 3.3V for this pin, if you don't use 3.3v you'll have to add a logic voltage converter at SCL and SDA to match with the ESP8266 3.3V levels.
- GND - Ground
- SCL - I2C clock
- SDA - I2C data
- AIN0 - Analog input 0 (0v to VDD)
- AIN1 - Analog input 1 (0v to VDD)
- AIN2 - Analog input 2 (0v to VDD)
- AIN3 - Analog input 3 (0v to VDD)

### **Dimensions**
1.00x0.50 inches (25.43x12.70 mm)


## **FAQs:**

- Q: Can I use two or more boards to have more than 4 analog inputs?
- A: No. You can only use one board per I2C master because each converter has a unique address, so using more than one board with the same I2C master means you'll have repeating addresses for all converters which will not allow you to communicate with any converter.
