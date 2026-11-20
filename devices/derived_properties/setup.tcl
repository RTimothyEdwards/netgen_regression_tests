permute default
property default
property parallel none
foreach side {1 2} {
    set dev "-circuit$side cap_mim"
    property $dev derive area w l
    property $dev derive perimeter w l
    property $dev parallel enable
    property $dev parallel {area add}
    property $dev parallel {perimeter add}
    property $dev tolerance {area 0.01} {perimeter 0.01}
    property $dev delete w l
}
