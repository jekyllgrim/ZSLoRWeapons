# ZScriptified Legacy of Rust weapons

Requires [GZDoom 4.12](https://github.com/ZDoom/gzdoom/releases) and the **id24res.wad** file from [Doom Rerelease](https://doom.bethesda.net/en-US/doom_doomii)

by Agent_Ash aka Jekyll Grim Payne

## What is this?

These are GZDoom versions of weapons from *Legacy of Rust*, a new campaign included with the Doom Rerelease.

**This mod DOES NOT INCLUDE SPRITES OR SOUNDS**. It only includes definitions for them, but you'll need to add **id24res.wad** from Doom Rerelease into your load order for them to work.

The only exception is customized muzzle flash sprites, which are modified from the ones that come with *Legacy of Rust*.

This mod is an exact mechanical replica, but NOT an exact visual replica of the weapons, because I wanted to add extra flair to them using ZScript.

## Contents

- **Incinerator** — original weapon by Xaser Acheron (ND)
  Plasma Rifle replacement. The mod modifies its fire and projectile animations a bit, so there's less quick flickering between sprite frames, making the animation smoother. It also adds some particle effects and more nuanced muzzle flash animation with more sprite variations.

- **Calamity Blade** (aka Heatwave Generator, as it's known in some parts of the game's code) — original weapon by Roger Berrones (id) & Xaser Acheron (ND)
  BFG9000 replacement. In the mod it has a slightly more nuanced muzzle flash, and the gun doesn't become fully bright when charging/firing, only the muzzle flash does. The projectiles also have lo-fi particle effects added.
  In addition to that, this version *does* allow for vertical autoaiming (in contrast to the *Legacy of Rust* version, which doesn't), but all fired projectiles will be aimed in sync.

## How to play

1. Download this archive: https://github.com/jekyllgrim/ZSLoRWeapons/archive/refs/heads/main.zip

2. 

## FAQ

#### Do I need this to play *Legacy of Rust* in GZDoom?

No. Legacy of Rust defines its weapons through DEHACKED, and GZDoom supports DEHACKED. You can just add *Legacy of Rust* WAD files to your load order, and it'll work out of the box.

This mod is mostly an excersize to show how these weapons can be done in ZScript, and it also adds a bit of visual flair to them.

#### Why aren't sprites and sounds included?

Because I don't own them and I don't know how the original authors would feel about me including them. If you own *Legacy of Rust*, you have access to them.

#### Are these mechanically different from the original Legacy of Rust weapons?

No. There are some visual differences.

#### Why does the Incinerator have a slower animation?

It's not slower per se, it's just smoothed out so the frames don't change as frequently. I find the original animation to be seizure-inducing due to animation frames changing every tic, and lighting going on and off frequently, and since it was bothering me, I decided to change that aspect.

#### Can I use this in my project?

Yes, but don't forget to credit Xaser Acheron and Roger Berrones (and, perhaps, me).
