DSi Cooking Coach exploit

This little project allows you to compile assembly straight into a
Cooking Coach save game file. This file can then be written to the game
card with something like eepinator from a normal DS.

The current assembly just paints the screens read, reads the save file from
eeprom to RAM then jumps into that where it paints the screen green.

If you find anything interesting then let us know in #dsdev on irc.blitzed.org

With thanks to Blasty for pointing me at modifying desmume to test exploit code.
Basically I added code to check the program counter for particular values which I
then added to the save file until it went bang.
 
Have fun,

Dave (WinterMute)

http://www.devkitpro.org
http://davejmurphy.com
http://twitter.com/davejmurphy
