# Derived device properties

Regression for [netgen issue #113](https://github.com/RTimothyEdwards/netgen/issues/113).
No PDK is needed. These small SPICE inputs exercise the area/perimeter
comparison used for rectangular capacitor geometries.

The LVS checks cover five layout filenames and four cases: identical
dimensions, an area mismatch, equal areas with different perimeters, and
swapped width/length with equal area and perimeter. Both mismatching cases
must report a final property failure; a topology match alone is insufficient.

The property checks use SPICE exports to verify that:

- width, length and unrelated properties survive adding derived values;
- a missing width or length is not inherited from the preceding instance;
- explicitly supplied area/perimeter values are preserved;
- instances after one with an explicit value still receive derived values;
- repeated calls, in either order, do not create duplicate properties;
- instances in twelve different cells are all visited;
- a second input file with the same device class is not modified.

The callback previously did not return a value, allocated a list that
overwrote the last original property, retained flags across instances, and
rewrote the list even if the requested property already existed. These
could cause missing checks, fabricated geometry, or a crash.

The missing return and list sizing fixes were suggested by @schwarzj99 in
the issue. Filename-dependent behavior is compiler-dependent; the regression
requires correct results for every name without relying on that symptom
appearing on an unpatched build.

This companion PR is draft until the source fix is released. Before merging,
add `require_netgen_version` with the actual first fixed release in `run.sh`.
