# Configuration

Good news! There is really not much to configure for this build-system. There is only one file that needs a bit of your attention if you run the scrips from the command-line. If you use the macOS frontend; it has its own settings in the usual place.

## `/config.zsh`
    
It needs to know where to find your stuff...

#!/bin/zsh

	#!/bin/zsh

	### Configuration of this build-system
	### ----------------------------------
	
	# Base directory of the books; full path. 
	# Used when making collections and all books.
	
	books="/Users/Desbeers/Documents/Leesvoer"
	
	# Export directory for the books; full path.
	# Automatically created if it does not exist.
	
	export="/Users/Desbeers/Documents/Mijn boeken"
	
	# PDF options
	# -----------
	# The options are from the LaTeX Memoir class.
	# See: https://www.ctan.org/pkg/memoir
	
	# The default papersize:
	
	papersize=ebook
	
	# The default fontsize:
	
	fontsize=11pt
  
And yeh; you can have spaces in your path name... As long as you have them between those nice quotes...
    
## Paper and font options

### Paper size

Those options are defined in the LaTeX Memoir class... Oops, that sounds pretty nerdy... Yes, because it is! See [their manual](https://www.ctan.org/pkg/memoir) if you want to know all the available options.

Just a few common ones: `ebook` (9 by 6 inches, my default), `a4paper`, `letterpaper`, and `legalpaper`. If you like more options, you know where to find the manual now.

### Font size

Again, defined in the LaTeX Memoir class. There are not so many options fortunately. They are `9pt`, `10pt`, `11pt`, `12pt` and `14pt`. And no, there is no `13pt`. I don’t know why, it’s simply not an option. Because... just because I guess...

---

Both options can be overruled in the `make-book.md` file for the individual books. How this is done I will explain later.

---

---

All the rest *is as it is*, as we always say at my job. That means, any other kind of customisation that you might want to do requires dirty hacking... Lucky for you, the code is full with comments to make your wishes at least *a bit* easier...

