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

- Fix the paths at the top of `build.sh` and run it. It should point to your actual KOTOR installation,
which is probably in a directory named `swkotor`.

- Pay attention to the CLI output! I've tried to make it obvious, via messages on stdout, which options
should be chosen when it isn't obvious.

    - When the HoloPatcher app is used, the CLI output will contain the path to use for the mod directory.
      Just copy and paste it into the UI. (Windows only, of course.)

- Profit!

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

> **NOTE:** Some of the mods are too large to store in github, so I've split them up. They'll need to be
  reconstituted before working with them. The split files are stored in separate subdirectories in,
  `mod-archives-splits`. The `unsplit.sh` script can reconstitute a mod from one of those directories.
  I still need to come up with something to reconstitute everything before installing.

Phase 2: Across the downloaded mods, some of them have very specific installation instructions. Since we
can't use a mod manager, it means we have to extract things into the overrides dir and manage the state
manually. In general, things that get extracted to the Override dir come first, overwriting anything that
conflicts that came before, and things that are installed via an executable come later because they tend
to ignore files that already exist, instead of overwriting them. My goal here is to make it as simple as
possible to apply the recommended set of mods for a clean install of KOTOR. I wanted to be able to store
a complete Override directory here, but these mods go beyond that, so the best I can do is create a
script that anyone could run that will install all the mods in a predictable way. By storing a copy of
all that here, I hope to make a reproducible build for a great KOTOR experience!

I expect this takes up quite a bit of space, but storage is cheap, right?? Plus, I can archive this in a
public GH project and save local space! My future goal is that running the game with all mods is a simple:

- Install game from steam.
- Clone this project (probably takes a while).
- Run this project's script to guide you through installing everything.
- Play!
