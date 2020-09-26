# Pandoc filters

All Pandoc filters are written in [Lua](https://pandoc.org/lua-filters.html). The order of running the filters is important; some of them are a bit destructive for the Pandoc’s *AST* (abstract syntax tree).

## Metadata filter

This filter sets default values for paper and font size if they are not in the book’s metadata file. The values are taken from the `config.zsh` file.

## Hashtags filter

I write my Markdown in iA Writer and that program writes hashtags (`#tag`) directly into the files. This filter removes them.

## Drop caps filter

Makes the first letter of the first paragraph after a `#` header a drop cap. This is done with the [Lettrine package](https://ctan.org/pkg/lettrine) for LaTeX and with CSS for ePub/html.

If there is a `blockquote` after a `#` header, it will not get a drop cap, however, the first paragraph after the quote wil get the drop cap.

If the paragraph starts with a quote (`”`), the quote-symbol will be before the dropped cap. The double quote is hard-coded; so sorry for those who use singles quotes.

This filter must run before the Header Filter or else the headers are most probably changed to something unusable for this filter.

Drop caps are not working in docx files because I don’t care too much about that format.

## Linebreaks filter

The `horizontal rule` is misused to get some space between two paragraphs. For LaTeX, it will be replaced by a `\bigskip`. For ePub/html by a `<div.bigskip>` and for docx by something I copied/pasted and seems to work.

## Chapter précis filter

The `######` header has a special function for me. I use it to write the date/place of a story after the `#` header. In Latex, it is a `\subparagraph` styles as a “Chapter précis ”and in ePub/html a div with class `chapterprecis`.

## Headers filter

When there are `\parts` in a book, the headers within those parts will be shifted for ePub, html and docx output. This is so that the TOC is correct.

If the `\parts` are also in a `\book`, as with collections; they are shifted twice.

## Matters filter

For Latex, it checks the Markdown for `.book`, `.part`, `.frontmatter`, `.mainmatter` and `.backmatter` classes and adds the corresponding LaTeX for that.

It also fiddles with the `\openany` and `\openright` options in the LaTeX output.

## Images filter

Figures for LaTeX will be rewritten, so it has a caption without "Fig:" in front and it will have the alignment that I like for all images.

The pictures default to a width of 92% when not set.

## Quotes filter

I like *double quotes* (`“”`) and this filter makes sure they are just like that; independent of what’s in the Markdown. A quote inside a quote will be a single quote (`‘’`).



