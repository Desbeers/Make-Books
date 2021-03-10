# LaTeX

Why make things easy if you can make it very difficult? Yes, give me one good reason *not* to use LaTeX for the layout of a very simple book... Just one good reason... Because it is very difficult? I like that... Because it’s like driving to the supermarket in a Ferrari? I don’t care... For you info; I play a *real* Fender Telecaster as *hobbyist* too, hahaha!

---

There was, and still is, a lot to learn for me when it comes to LaTeX. But, that’s the reason why I use it. I like the challenge and even more I like the great results you can get if you just keep trying hard enough.

## The template

I use the `Memoir class` as base for my templates. The `/tex/latex/` folder has the first part of my template; providing it’s own class. The Pandoc template in `/pandoc/templates` is using this class.

## The `$TEXMFHOME` path

The `/includes/variable.zsh` script sets the TEXMFHOME variable to this build-system so LuaLaTeX can actually find its stuff:

	# For LaTeX, set TEXMFHOME to these scripts:
	export TEXMFHOME=$local/texmf

Once the script is done and the terminal session is closed; everything is again back to normal. So, that means if you fiddle with the `build-scrips` and you expect LuaLaTeX to find your own stuff you are out of luck... Now you know why...

## Fonts

I’m using LuaLaTeX for the actual compiling and that means the system fonts are available for me. Yeh, great! For me... However, nice guy that I am, what about you?

You most probably don’t have that charming font on your system that I use for `drop caps`. So, for you, yes, special for you, I found out  after a long time how to get this right. Install this font on your computer.

Don’t just change this font for a different one; the result will not be pleasant. And you will hurt my feelings as well, because, really, it took me a long time to get this right.

## Whining and crying

LaTeX can be a bitch. One character in the wrong place and boom! A cryptical punishment will follow. It looks like LaTeX doesn’t really like any other character than A to Z, hahaha!

If you edit your `make-book.md` for example; sometimes you can use the `":"`, sometimes you can’t. I’m afraid it depends on the direction of the wind sometimes... LaTeX is mysterious...

