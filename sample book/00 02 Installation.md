# Installation

A basic technical knowledge is required to use this system; it’s working from the `terminal`. However, I will give it a fair try to help you with it. As always, [Google](https://google.com) is your best friend if you read this chapter and it makes no sense to you, haha!

---

This system is only tested on macOS Catalina and Ubuntu 20.04. There is no Windows support and that is also not a my todo list; I have no clue about that system.

## Software

The following software must be installed on your computer:

- [`Pandoc`](https://pandoc.org), the swiss-army knife for file converting.
- A `LaTeX` distribution like [MacTEX](http://www.tug.org/mactex/) for the Mac. For Ubuntu, I did `sudo apt install texlive-full` to get all the goodies in one time and no complains about missing packages.
- The `zsh` shell; standard on macOS Catalina; install it on Ubuntu.
- `rsync`; should be standard...
- The `Make` program. Part of Xcode or grab it from [Homebrew](https://brew.sh) when you are on a Mac. Else; do your Linux magic.
- For a ‘Kobo’ ePub, ‘kepubify’ is needed. Get it [here](https://pgaskin.net/kepubify/). 

## Font

The “drop caps” font `GreatVibes` has to be be installed on your system. It’s in the `fonts` folder. On Mac, use `fontbook`. On Linux, as always, find your own way. If the font is not properly installed you get the following friendly warning:

	Package fontspec Error: The font "GreatVibes" cannot be found.

And the whole fun stops... I’ll tried to “just use the font from the folder” and, although I could get that done, it gave more troubles... LuaLaTeX remembers where fonts are and will never forget it; unless you do magic... Didn’t want to do that kind of magic; not worth the risk of breaking even more. So... just install the font, it’s gorgeous!

For PDF, the font `otf-cm-unicode` is used. You have to have it installed as part of your LaTeX installation. For Arch Linux, it is in the ‘aur’.

## Place the folder

The content of the `Make-books` repo can be copied to any location on your computer. Mine is in `~/Documents/Leesvoer/scripts` for example. Only one thing, don’t move any files inside this folder, keep them in place.

## Add the scripts to your `$PATH`

The folder `/terminal` has the shell scripts to make the books. It’s handy to have this folder in your `$PATH`; saving you a lot of typing.

On my Mac, I dropped a file containing the full path to the scripts: \
`/Users/Desbeers/Documents/Leesvoer/scripts/terminal` into the folder `/etc/paths.d`. That did the job for me.

---

Linux? Up to you!

---

That’s it! Now a bit of configuration and you’re good to go!


