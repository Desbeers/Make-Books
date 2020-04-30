# The anatomy of a book

Ok, let’s have a look at the structure of a book. Not being an expert, I might use the wrong wording once in a while, but that’s ok I hope. It is not rocket-science, so I’m pretty sure my explanation will be good enough. I’ll trow in a bit of LaTeX terminology because, well, that’s the only terminology I know, haha!

---

Please not that is *not* the really the technical structure of the book created by this build-system; it’s just to give it a general idea.

## The book:

	
	cover page (optional)
	half title
	title
	copyright
	dedication (optional)
	table of contents
	\frontmatter
	foreword (for example)
	\mainmatter
	\part (optional)
	chapter 1
	chapter 2
	\part (optional)
	chapter 3
	chapter 4
	\backmatter (optional)
	afterword (for example)

That’s it! That’s the anatomy for a book. At least, for my books.

---

A bit of additional explanation:

## Half title & title

This is just something I see in my “real books” at home. Real books just have that. On the first page the “half title” which is actually *not* half the title, but only the title and not the author. Don’t know why they call that kind of page *half title* but that’s the official name.
The second page is the title of the book, followed by the authors name. It’s called the *title* page; even thought it has the title *and* the author.
Anyway, I like that look, so here it is!

## Copyright

This page will automatically created based on the provided metadata. See next chapter for that.

## Dedication

Maybe not the correct name, but it is a page that comes before the table of contents. I use it as dedication page but you can use it for whatever you like.

## \\frontmatter

These are the pages that will go before the start of your *real* content. A foreword for example, or an introduction.

## \\part

A book can be divided into *parts*. Maybe for *episodes* for example. Further-on I will explain how to make those parts.

## \\backmatter

These are the pages that will go after your *real* content has ended. You can use it for an afterword for example.







