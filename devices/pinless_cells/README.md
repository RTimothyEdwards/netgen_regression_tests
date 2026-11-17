# pinless_cells

Cells with no pins, such as decap or fill cells in a netlist without power
pins, are given a single placeholder pin "(no pins)" that is not connected
to any net.  When several are merged as parallel devices, they get a
property record, and the property check compared the connections of their
pins, looking up a net for the placeholder pin.  In netgen 1.5.330 and
earlier, that crashed netgen (segmentation fault).  Here the two netlists
are the same and must match.
