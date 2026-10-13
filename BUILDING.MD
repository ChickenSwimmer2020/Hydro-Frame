# BUILDING

> So you wanna build Hydro-Frame, go ahead


## Setup

### Mac

* Make sure you have XCode installed from the app store

### Other platforms

¯\\_(ツ)\_/¯

## Begin

* Install [haxe](https://haxe.org/)
* download Hydro-Frame's repo (skip if you already have)
* in your terminal, run
```
haxelib newrepo
haxelib --global install hmm
haxelib --global run hmm setup
hmm install (This will take a bit)
```

If you are on mac you will run

```
lime rebuild mac -y
```

otherwise run

```
lime rebuild cpp -y
```

and now

```
haxelib run lime setup
lime rebuild hxcpp -y
lime rebuild tools -y
```
* run `lime` in the console and make sure it worked
* run `lime test <platform>` or `lime test <platform> -debug` (This will *also* take some time!)
