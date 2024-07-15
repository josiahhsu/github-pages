$carts = ls source/*.p8
foreach($cart in $carts)
{
    $cartname = (Get-Item $cart).BaseName
    write-host $("Exporting " + $cartname)

    pico8 $cart -export $("exports/" + $cartname + ".js")
    pico8 $cart -export $("-l exports/" + $cartname + ".png")
}
