# Luminifu
A functional RGB display manager (server side).

Most of this project has never been tested and has never (yet) driven anything (ie it will probably break!), be careful!

The goal of this is to write a very functional (as in function) RGB display manager.
Thanks to this general approach, it can be adapted to nearly every setup.


Display philosphy
-----------------
The approach is to generate a function `f` that will then be sampled with a function `s` to return an array.
This has multiple advantages: only `s` needs to know the actual details of the display, it then projects this into whatever space `f` is implemented in (line, grid, torus, etc...).
`s` can also be changed to create interesting effects: waves, having it wrap around, shifting or scaling...
Given this freedom, `f` can be almost anything you want it to be!

Real world interface
--------------------
This has *not* yet been implemented, so far it prints a single frame to stdout.

Here is a rough sketch of how the protocol would work (take this as a braindump, not as an implementation promise):

0. the server has at least one "device" configured. This includes everything from the generating function to the display details.
0. client asks server for the frame for a specific device at a specific time.
0. server obliges and gives the frame in RGB triplets (0 to 255)
0. client does its thing

Here are a few things worth thinking about:
- should the client be able to say "hey, I want you to add a device that looks like $this"?
- should the client be able to ask for a frame in the future?
 - I think this is not a problem, but what if the function relies on some real world input (music, position in space...) and it can't produce a frame that far in advance, does it just wait?
