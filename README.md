# Luminifu
A functional RGB display manager.

The goal of this is to write a very functional (as in function) RGB display manager.
Thanks to this general approach, it can be adapted to nearly every setup.


Display philosphy
-----------------
`f` is a function that is your perfect colourfull world.
This world will then be sampled at certain points return an array.
The sampling is done through a projection function `p`, so the morphology of the display (say a strip) is the input (for a strip, it would be an array).

To summarize, the display is projected (`s`) into an arbitrary world of color (`f`).

This has multiple advantages: only `s` needs to know the actual details of the display, it then projects this into whatever space `f` is implemented in (line, grid, torus, etc...).
`s` can also be changed to create interesting effects: waves, having it wrap around, shifting or scaling...
Given this freedom, `f` can be almost anything you want it to be!

Network interface
-----------------

Brain side:

0. Brain tries to connect to device
0. If successful brain sends all-black frame and waits
0. Brain waits for device to ask it for the frame at time `t`

Device side:

0. Device waits for frames
0. After receiving and displaying the frame, requests the frame associated with time `t

It is interesting to note that in this protocol, the devices are "servers" and the brain is a "centralized client".

This is implemented right above TCP.
The frames are communicated in hex form, a 3 pixel red to black gradient would be "#ff0000#880000#000000".
