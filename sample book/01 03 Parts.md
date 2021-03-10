# Parts, dedication, and other special pages

A chapter is a chapter, plain and simple. But what about the other bits and pieces that makes a book *a book*?

---

Special pages are also written in Pandoc’s Markdown. To let the build-system knows if a page is special, you have to add a `class` to your heading. That’s all. All these files, except the `dedication` page are living in the same folder as your *normal* content. So, order is important! See *the folder structure for your book* page in this book.

## Frontmatters

The `frontmatter` pages should go before you start any chapter or optional `part` page. Please note this should not be a *dedication* page. It can be a foreword for example.

To make a `\frontmatter` page, write the following header:

	# My frontmatter title {.frontmatter}

And ten just write whatever you want to write. You can have as many `frontmatters` as you like; as long as they have all the above class added.

## Parts

To make a `\part` page, write the following header:

	# My part title {.part}
	
Parts can have normal text as well; just like any other chapter, frontmatter or backmatter page. It’s just styled in a different way to make it look like a real part division. A PDF part-page will always start on the right; followed by an empty page.

## Backmatters

To make a `\backmatter` page, write the following header:

	# My backmatter title {.backmatter}

And then, write along again. You can have as many `backmatters` as you like; as long as they have all the above class added.

## Dedication

A `dedication` page is a separate Markdown file that lives in the `/assets` folder. See the chapter about the folder structure of your book later on. It does not need any `class`; you just write it like a chapter page. It will be between the *copyright* and *table of contents* pages in your book.

