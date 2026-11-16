# full_pin_list

When the netlists do not match, the pin list printed for the top cell
("Subcircuit pins:") must still list every pin of both cells.

In the schematic, net `e` has been merged into net `b`, so the schematic has
one net fewer than the layout and port `e` is left unconnected.  The
partition of nets then has a group with more nets from the layout than from
the schematic.  Netgen used to stop printing the pin list at the first such
net, without the closing divider line, and reported "Cell pin lists are
equivalent."  Fixed in netgen 1.5.329.
