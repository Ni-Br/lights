# lights (name pending...)
A functional RBG display manager.

Most of this project has never been tested and has never yet driven anything (ie it will probably break!), be careful!

The goal of this is to write a very functional RGB display manager.
Thanks to this general approach, it can be adapted to nearly every setup.

Colors
------
The Data.Colour module is used, and ultimately an array of Data.Colour is produced.
You can then interpret this however you whish.

Display philosphy
-----------------
The approach is to generate a function $f$ that will then be sampled with a function $s$ to return an array.
This has multiple advantages: only $s$ needs to know the actual details of the display, it then projects this into whatever space $f$ is implemented in (line, grid, torus, etc...)
$s$ can also be changed to create interesting effects: waves, having it wrap around, shifting or scaling...
Given this freedom, $f$ can be almost anything you want it to be!

Real world
----------
This has not yet been implemented, but in the works is to create two interfaces: a network one (TCP or UDP, undecided) and an SPI one (for LPD6803).
