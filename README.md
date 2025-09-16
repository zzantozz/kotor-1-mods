# Knights of the Old Republic mods

This is the home of kotor 1 mods. I'm following this guide, which seems to be the gold standard for modding:
https://kotor.neocities.org/modding/mod_builds/k1/spoiler-free

## Note for visitors other than me

Welcome, outsider! If you've stumbled across this, you should know that this project is specifically tailored
to my setup. It's a public github project because that gives me free storage for this monstrosity. That said,
the only stuff that really makes it specific to me is:

- my choice of mods to use: I pretty much followed the guide's suggestions

- my screen resolution (presently set to 2560x1440 (1440p)

If these things are acceptable to you, or if you can adapt your expectations to mine, then this should work
for you just as well as it does for me! If it's just a matter of resolution differences, then you should be
able to use almost everything here and just update a relative handful of the files to account for the
difference. You should look at the mod guide linked above to find the mods that rely on picking a specific
resolution.

If someone wants to come up with a specific list of resolution dependant mods to include here, I'm happy to
consider PRs!

## Quick version

- Just copy the contents of `overrides-dir` into your `swkotor/overrides` dir, wherever that happens to be.
(It's in your steam dir.)

- Start a new game.

## Details

There are a ton of mods to install, and the guide claims you can't use a mod manager. You have to install
everything manually. That makes it really complicated to mod this game because of the number of mods and
possible interactions between them. Therefore, I'm trying to keep track of everything needed to mod it in
the simplest way possible. I'm following the "spoiler free mod builds" part of the guide.

> **NOTE:** You can't install these things mid-game. Once you add all this stuff, your previous saves won't
  work, so you have to start a fresh game instead.

Phase 1: Download all the mods. I'm not being terribly picky. For each mod mentioned in the guide, I've
downloaded the necessary file(s). When there are multiple choices, I've almost always (or always?) followed
the guide's advice. I'm going to store all the downloaded archives here for posterity. On my first attempt
on 14 Sep 2025, there was no problem downloading everything listed in the guide. Who knows if that will
continue in the future? Storing everything here makes it future-proof.

> **NOTE:** At least one of these mods (at the time of writing) is too large to store in github. That's
  `Resolution\ 2560x1440-1306-1-1-1575389956.zip`, the general resolution upgrade. I've used 7zip to split
  the archive into two pieces, so if you want to go back to the raw archive files, you'll have to extract
  those as an initil step to get the original file.

Phase 2: Across the downloaded mods, some of them have very specific installation instructions. Since we
can't use a mod manager, it means we have to extract things into the overrides dir and manage the state
manually. My goal is to end up with a complete and correct overrides dir stored here. To that end, I've
prepped it all by following all of the extraction instructions to the letter. Ideally, if I ever want to
play this in the future, my goal is that all I have to do is copy this repo's overrids dir into a fresh
installation of the game's overrides dir, and everything will work. (Why hasn't someone done this already????)

I expect this takes up quite a bit of space, but storage is cheap, right?? Plus, I can archive this in a
public GH project and save local space! My future goal is that running the game with all mods is a simple:

- Install game from steam.
- Clone this project (probably takes a while).
- rsync or copy/paste this project's `overrides/` to `<steam dir>/swkotor/overrides/`.
- Play!
