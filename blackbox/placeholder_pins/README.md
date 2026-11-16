# placeholder_pins

Devices that are called as subcircuits but never defined (common when a
netlist uses PDK device subcircuits without including their definitions)
become placeholder cells, which are compared as black boxes by their pins.
The pins must actually be compared, and here they match.

The script runs `flatten` on a cell before `lvs`, as some LVS scripts do,
which makes netgen elaborate the netlists first.  In netgen 1.5.330 before
this test was added, `equate pins` returned without comparing the pins when
there was no "current cell" ("Equate elements:  no current cell"), which
could happen after elaboration (seen in a real LVS run, though not
reproduced by this small example).  This test guards the black box pin
comparison in that flow.
