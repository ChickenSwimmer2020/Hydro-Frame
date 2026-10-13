# BUILDING

So you wanna build Hydro-Frame, go ahead
>placeholder MSG, please rewrite this.

## BUILDING[ios]

>TODO

## BUILDING[android]

>TODO

## BUILDING[windows]

* Install [haxe](https://haxe.org/)
* download Hydro-Frame's repo (skip if you already have)
* in your terminal, run `haxelib install format; haxelib install hxp; haxelib git hxcpp https://github.com/CodenameCrew/cne-hxcpp; haxelib git lime https://github.com/ZSolarDev/cne-lime develop; haxelib run lime setup -y; lime rebuild hxcpp; lime rebuild tools; haxelib git openfl https://github.com/CodenameCrew/cne-openfl develop; haxelib install svg 1.2.0; haxelib install clipper; haxelib install hxcpp-debugger` (This may take some time!)
* run `lime` in the console and make sure it worked
* (optional) run `haxelib setup` to set haxelib path
* run `lime test windows -debug` (This may *also* take some time!)

## BUILDING[mac]

* Make sure you have XCode installed from the app store
* Install [haxe](https://haxe.org/)
* download Hydro-Frame's repo (skip if you already have)
* in your terminal, run `haxelib install format; haxelib install hxp; haxelib git hxcpp https://github.com/CodenameCrew/cne-hxcpp; haxelib git lime https://github.com/ZSolarDev/cne-lime develop; lime rebuild mac; haxelib run lime setup -y; lime rebuild hxcpp; lime rebuild tools; haxelib git openfl https://github.com/CodenameCrew/cne-openfl develop; haxelib install svg 1.2.0; haxelib install hxcpp-debugger` (This may take some time!)
* run `lime` in the console and make sure it worked
* (optional) run `haxelib setup` to set haxelib path
* run `lime test mac -debug` (This may *also* take some time!)
