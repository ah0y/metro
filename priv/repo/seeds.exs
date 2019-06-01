# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Metro.Repo.insert!(%Metro.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Metro.Location.Book
alias Metro.Location.Copy
alias Metro.Location.Author
alias Metro.Location.Library
alias Metro.Account.User
alias Metro.Account.Card

Metro.Repo.insert!(
  %Author{
    first_name: "Haruki",
    last_name: "Murakami",
    location: "Japan",
    bio: "Haruki Murakami was born in Kyoto in 1949 and now lives near Tokyo. His work has been translated into more than fifty languages, and the most recent of his many international honors is the Jerusalem Prize, whose previous recipients include J. M. Coetzee, Milan Kundera, and V. S. Naipaul.",
    books: [
      %Book{
        isbn: 9780679446698,
        title: "The Wind-Up Bird Chronicle",
        year: 1997,
        summary: "In a Tokyo suburb a young man named Toru Okada searches for his wife's missing cat.  Soon he finds himself looking for his wife as well in a netherworld that lies beneath the placid surface of Tokyo.  As these searches intersect, Okada encounters a bizarre group of allies and antagonists: a psychic prostitute; a malevolent yet mediagenic politician; a cheerfully morbid sixteen-year-old-girl; and an aging war veteran who has been permanently changed by the hideous things he witnessed during Japan's forgotten campaign in Manchuria.",
        pages: 613,
        image: "https://contentcafe2.btol.com/ContentCafe/Jacket.aspx?&userID=CLOH21163&password=CC44366&Value=9780679446699&content=M&Return=1&Type=M"
      },
      %Book{
        isbn: 9780307593313,
        title: "1Q84",
        year: 2011,
        summary: "An ode to George Orwell's \"1984\" told in alternating male and female voices relates the stories of Aomame, an assassin for a secret organization who discovers that she has been transported to an alternate reality, and Tengo, a mathematics lecturer and novice writer.",
        pages: 925,
        image: "https://contentcafe2.btol.com/ContentCafe/Jacket.aspx?&userID=CLOH21163&password=CC44366&Value=9780307593313&content=M&Return=1&Type=M"
      }
    ]
  }
)

Metro.Repo.insert!(
  %Library{
    address: "3434 E Livingston Ave, Columbus, OH 43227, USA",
    image: "https://librarytechnology.org/photos-libraries/12878.jpg",
    hours: "Sunday 1 to 5pm",
    branch: "Columbus Metropolitan Library Livingston Branch",
    copies: [
      %Copy{
        isbn_id: 9780679446698,
        checked_out?: true
      },
      %Copy{
        isbn_id: 9780307593313,
        checked_out?: false
      }
    ]
  }
)

Metro.Repo.insert!(
  %User{
    name: "abe",
    email: "test@gmail.com",
    password: "password",
    password_hash: "$2b$12$yPfPx1nWGe3yb/UfLfPy.Op9REGVuZbVze85heRgsu9uAVj7/MTUK",
    fines: 0.00,
    num_books_out: 0,
    is_librarian?: true,
    card:
      %Card{
        pin: "0123"
    }
  }
)

#
#Metro.Repo.insert!(
#  %Book{
#    isbn: 3,
#    title: "The Wind-Up Bird Chronicle",
#    author_id: 1,
#    year: 1997,
#    summary: "In a Tokyo suburb a young man named Toru Okada searches for his wife's missing cat.  Soon he finds himself looking for his wife as well in a netherworld that lies beneath the placid surface of Tokyo.  As these searches intersect, Okada encounters a bizarre group of allies and antagonists: a psychic prostitute; a malevolent yet mediagenic politician; a cheerfully morbid sixteen-year-old-girl; and an aging war veteran who has been permanently changed by the hideous things he witnessed during Japan's forgotten campaign in Manchuria.",
#    pages: 613,
#    image: "https://contentcafe2.btol.com/ContentCafe/Jacket.aspx?&userID=CLOH21163&password=CC44366&Value=9780679446699&content=M&Return=1&Type=M"
#  }
#)

#Metro.Repo.insert!(
#  %Book{
#    isbn: 4,
#    title: "The Wind-Up Bird Chronicle",
#    author_id: 1,
#    year: 1997,
#    summary: "In a Tokyo suburb a young man named Toru Okada searches for his wife's missing cat.  Soon he finds himself looking for his wife as well in a netherworld that lies beneath the placid surface of Tokyo.  As these searches intersect, Okada encounters a bizarre group of allies and antagonists: a psychic prostitute; a malevolent yet mediagenic politician; a cheerfully morbid sixteen-year-old-girl; and an aging war veteran who has been permanently changed by the hideous things he witnessed during Japan's forgotten campaign in Manchuria.",
#    pages: 613,
#    image: "https://contentcafe2.btol.com/ContentCafe/Jacket.aspx?&userID=CLOH21163&password=CC44366&Value=9780679446699&content=M&Return=1&Type=M"
#  }
#)
#
#Metro.Repo.insert!(
#  %Book{
#    isbn: 5,
#    title: "The Wind-Up Bird Chronicle",
#    author_id: 1,
#    year: 1997,
#    summary: "In a Tokyo suburb a young man named Toru Okada searches for his wife's missing cat.  Soon he finds himself looking for his wife as well in a netherworld that lies beneath the placid surface of Tokyo.  As these searches intersect, Okada encounters a bizarre group of allies and antagonists: a psychic prostitute; a malevolent yet mediagenic politician; a cheerfully morbid sixteen-year-old-girl; and an aging war veteran who has been permanently changed by the hideous things he witnessed during Japan's forgotten campaign in Manchuria.",
#    pages: 613,
#    image: "https://contentcafe2.btol.com/ContentCafe/Jacket.aspx?&userID=CLOH21163&password=CC44366&Value=9780679446699&content=M&Return=1&Type=M"
#  }
#)
#
#Metro.Repo.insert!(
#  %Book{
#    isbn: 6,
#    title: "The Wind-Up Bird Chronicle",
#    author_id: 1,
#    year: 1997,
#    summary: "In a Tokyo suburb a young man named Toru Okada searches for his wife's missing cat.  Soon he finds himself looking for his wife as well in a netherworld that lies beneath the placid surface of Tokyo.  As these searches intersect, Okada encounters a bizarre group of allies and antagonists: a psychic prostitute; a malevolent yet mediagenic politician; a cheerfully morbid sixteen-year-old-girl; and an aging war veteran who has been permanently changed by the hideous things he witnessed during Japan's forgotten campaign in Manchuria.",
#    pages: 613,
#    image: "https://contentcafe2.btol.com/ContentCafe/Jacket.aspx?&userID=CLOH21163&password=CC44366&Value=9780679446699&content=M&Return=1&Type=M"
#  }
#)
#
#Metro.Repo.insert!(
#  %Book{
#    isbn: 7,
#    title: "The Wind-Up Bird Chronicle",
#    author_id: 1,
#    year: 1997,
#    summary: "In a Tokyo suburb a young man named Toru Okada searches for his wife's missing cat.  Soon he finds himself looking for his wife as well in a netherworld that lies beneath the placid surface of Tokyo.  As these searches intersect, Okada encounters a bizarre group of allies and antagonists: a psychic prostitute; a malevolent yet mediagenic politician; a cheerfully morbid sixteen-year-old-girl; and an aging war veteran who has been permanently changed by the hideous things he witnessed during Japan's forgotten campaign in Manchuria.",
#    pages: 613,
#    image: "https://contentcafe2.btol.com/ContentCafe/Jacket.aspx?&userID=CLOH21163&password=CC44366&Value=9780679446699&content=M&Return=1&Type=M"
#  }
#)
#
#Metro.Repo.insert!(
#  %Book{
#    isbn: 8,
#    title: "The Wind-Up Bird Chronicle",
#    author_id: 1,
#    year: 1997,
#    summary: "In a Tokyo suburb a young man named Toru Okada searches for his wife's missing cat.  Soon he finds himself looking for his wife as well in a netherworld that lies beneath the placid surface of Tokyo.  As these searches intersect, Okada encounters a bizarre group of allies and antagonists: a psychic prostitute; a malevolent yet mediagenic politician; a cheerfully morbid sixteen-year-old-girl; and an aging war veteran who has been permanently changed by the hideous things he witnessed during Japan's forgotten campaign in Manchuria.",
#    pages: 613,
#    image: "https://contentcafe2.btol.com/ContentCafe/Jacket.aspx?&userID=CLOH21163&password=CC44366&Value=9780679446699&content=M&Return=1&Type=M"
#  }
#)
#
#Metro.Repo.insert!(
#  %Book{
#    isbn: 9,
#    title: "The Wind-Up Bird Chronicle",
#    author_id: 1,
#    year: 1997,
#    summary: "In a Tokyo suburb a young man named Toru Okada searches for his wife's missing cat.  Soon he finds himself looking for his wife as well in a netherworld that lies beneath the placid surface of Tokyo.  As these searches intersect, Okada encounters a bizarre group of allies and antagonists: a psychic prostitute; a malevolent yet mediagenic politician; a cheerfully morbid sixteen-year-old-girl; and an aging war veteran who has been permanently changed by the hideous things he witnessed during Japan's forgotten campaign in Manchuria.",
#    pages: 613,
#    image: "https://contentcafe2.btol.com/ContentCafe/Jacket.aspx?&userID=CLOH21163&password=CC44366&Value=9780679446699&content=M&Return=1&Type=M"
#  }
#)
#
#Metro.Repo.insert!(
#  %Book{
#    isbn: 10,
#    title: "The Wind-Up Bird Chronicle",
#    author_id: 1,
#    year: 1997,
#    summary: "In a Tokyo suburb a young man named Toru Okada searches for his wife's missing cat.  Soon he finds himself looking for his wife as well in a netherworld that lies beneath the placid surface of Tokyo.  As these searches intersect, Okada encounters a bizarre group of allies and antagonists: a psychic prostitute; a malevolent yet mediagenic politician; a cheerfully morbid sixteen-year-old-girl; and an aging war veteran who has been permanently changed by the hideous things he witnessed during Japan's forgotten campaign in Manchuria.",
#    pages: 613,
#    image: "https://contentcafe2.btol.com/ContentCafe/Jacket.aspx?&userID=CLOH21163&password=CC44366&Value=9780679446699&content=M&Return=1&Type=M"
#  }
#)
#
#Metro.Repo.insert!(
#  %Book{
#    isbn: 11,
#    title: "The Wind-Up Bird Chronicle",
#    author_id: 1,
#    year: 1997,
#    summary: "In a Tokyo suburb a young man named Toru Okada searches for his wife's missing cat.  Soon he finds himself looking for his wife as well in a netherworld that lies beneath the placid surface of Tokyo.  As these searches intersect, Okada encounters a bizarre group of allies and antagonists: a psychic prostitute; a malevolent yet mediagenic politician; a cheerfully morbid sixteen-year-old-girl; and an aging war veteran who has been permanently changed by the hideous things he witnessed during Japan's forgotten campaign in Manchuria.",
#    pages: 613,
#    image: "https://contentcafe2.btol.com/ContentCafe/Jacket.aspx?&userID=CLOH21163&password=CC44366&Value=9780679446699&content=M&Return=1&Type=M"
#  }
#)
#
#Metro.Repo.insert!(
#  %Book{
#    isbn: 12,
#    title: "The Wind-Up Bird Chronicle",
#    author_id: 1,
#    year: 1997,
#    summary: "In a Tokyo suburb a young man named Toru Okada searches for his wife's missing cat.  Soon he finds himself looking for his wife as well in a netherworld that lies beneath the placid surface of Tokyo.  As these searches intersect, Okada encounters a bizarre group of allies and antagonists: a psychic prostitute; a malevolent yet mediagenic politician; a cheerfully morbid sixteen-year-old-girl; and an aging war veteran who has been permanently changed by the hideous things he witnessed during Japan's forgotten campaign in Manchuria.",
#    pages: 613,
#    image: "https://contentcafe2.btol.com/ContentCafe/Jacket.aspx?&userID=CLOH21163&password=CC44366&Value=9780679446699&content=M&Return=1&Type=M"
#  }
#)
#
#Metro.Repo.insert!(
#  %Book{
#    isbn: 13,
#    title: "The Wind-Up Bird Chronicle",
#    author_id: 1,
#    year: 1997,
#    summary: "In a Tokyo suburb a young man named Toru Okada searches for his wife's missing cat.  Soon he finds himself looking for his wife as well in a netherworld that lies beneath the placid surface of Tokyo.  As these searches intersect, Okada encounters a bizarre group of allies and antagonists: a psychic prostitute; a malevolent yet mediagenic politician; a cheerfully morbid sixteen-year-old-girl; and an aging war veteran who has been permanently changed by the hideous things he witnessed during Japan's forgotten campaign in Manchuria.",
#    pages: 613,
#    image: "https://contentcafe2.btol.com/ContentCafe/Jacket.aspx?&userID=CLOH21163&password=CC44366&Value=9780679446699&content=M&Return=1&Type=M"
#  }
#)
#
#Metro.Repo.insert!(
#  %Book{
#    isbn: 14,
#    title: "The Wind-Up Bird Chronicle",
#    author_id: 1,
#    year: 1997,
#    summary: "In a Tokyo suburb a young man named Toru Okada searches for his wife's missing cat.  Soon he finds himself looking for his wife as well in a netherworld that lies beneath the placid surface of Tokyo.  As these searches intersect, Okada encounters a bizarre group of allies and antagonists: a psychic prostitute; a malevolent yet mediagenic politician; a cheerfully morbid sixteen-year-old-girl; and an aging war veteran who has been permanently changed by the hideous things he witnessed during Japan's forgotten campaign in Manchuria.",
#    pages: 613,
#    image: "https://contentcafe2.btol.com/ContentCafe/Jacket.aspx?&userID=CLOH21163&password=CC44366&Value=9780679446699&content=M&Return=1&Type=M"
#  }
#)