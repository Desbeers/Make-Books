# Compiling all books in one time

Inside the `/terminal` folder, there is another handy script. It’s called `make-all-books` and guess what it does? Yes, it will compile all the books the script can find.

---

It does this by sniffing your whole disk starting from the folder defined in `config.zsh`.

---

It just search for every `make-book.md` file; double-checks if it  is actually a book and then tells the `make-book` script to compile that book for you. All automatically, wow!

---

All arguments are the same as with the single `make-book` script.

---

So, to compile all and every book to a PDF, just run the following command in the terminal:

	make-all-books pdf
	
Assuming you put the scripts into your `$path` as described on the installation page of this book, you can run this script from anywhere.
