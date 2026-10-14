# BUILDING

> MAC ONLY:
> Make sure you have XCode installed from the app store

- Install [haxe](https://haxe.org/)
- Download Hydro-Frame's repo (skip if you already have)
- Run:

```
haxelib install hmm
haxelib run hmm setup
hmm install (This will take a bit)
```

- If you are on mac run

```
haxelib run lime rebuild mac --always 
```

- otherwise run

```
haxelib run lime rebuild cpp --always
```

- And now run

```
haxelib run lime setup
lime rebuild hxcpp -y
lime rebuild tools -y
```

- run `lime` in the console and make sure it worked (If it didn't please report it and you will be helped for troubleshooting)
- run `lime test <platform>` or `lime test <platform> -debug` (This will _also_ take some time!)
