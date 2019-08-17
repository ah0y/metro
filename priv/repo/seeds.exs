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
alias Metro.Location.Room
alias Metro.Location.Event
alias Metro.Location.Genre

import Ecto.Query


Metro.Repo.insert!(
  %Genre{
    category: "Romance"
  }
)

Metro.Repo.insert!(
  %Genre{
    category: "Comedy"
  }
)

Metro.Repo.insert!(
  %Genre{
    category: "Kids"
  }
)

Metro.Repo.insert!(
  %Genre{
    category: "Adventure"
  }
)

Metro.Repo.insert!(
  %Genre{
    category: "Fiction"
  }
)

Metro.Repo.insert!(
  %Genre{
    category: "Non-Fiction"
  }
)

Metro.Repo.insert!(
  %Genre{
    category: "Fantasy"
  }
)

Metro.Repo.insert!(
  %Genre{
    category: "Teen"
  }
)

Metro.Repo.insert!(
  %Genre{
    category: "History"
  }
)

Metro.Repo.insert!(
  %Genre{
    category: "Historical Fiction"
  }
)

Metro.Repo.insert!(
  %Genre{
    category: "Eastern"
  }
)

Metro.Repo.insert!(
  %Genre{
    category: "Technical"
  }
)

Metro.Repo.insert!(
  %Genre{
    category: "Drama"
  }
)

Metro.Repo.insert!(
  %Genre{
    category: "Comic"
  }
)

Metro.Repo.insert!(
  %Genre{
    category: "Biography"
  }
)

Metro.Repo.insert!(
  %Genre{
    category: "Thriller"
  }
)

Metro.Repo.insert!(
  %Genre{
    category: "Mystery"
  }
)

Metro.Repo.insert!(
  %Genre{
    category: "Horror"
  }
)

Metro.Repo.insert!(
  %Genre{
    category: "Crime"
  }
)

Metro.Repo.insert!(
  %Genre{
    category: "Medieval"
  }
)

Metro.Repo.insert!(
  %Genre{
    category: "Science Fiction"
  }
)

Metro.Repo.insert!(
  %Genre{
    category: "Poetry"
  }
)

Metro.Repo.insert!(
  %Genre{
    category: "Tragedy"
  }
)

Metro.Repo.insert!(
  %Genre{
    category: "Fable"
  }
)

Metro.Repo.insert!(
  %Genre{
    category: "Satire"
  }
)

Metro.Repo.insert!(
  %Genre{
    category: "Essay"
  }
)

Metro.Repo.insert!(
  %Genre{
    category: "Action"
  }
)

Metro.Repo.insert!(
  %Author{
    first_name: "Haruki",
    last_name: "Murakami",
    location: "Japan",
    bio: "Haruki Murakami was born in Kyoto in 1949 and now lives near Tokyo. His work has been translated into more than fifty languages, and the most recent of his many international honors is the Jerusalem Prize, whose previous recipients include J. M. Coetzee, Milan Kundera, and V. S. Naipaul.",
    books: [
      %Book{
        isbn: 9780679446699,
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
      },
      %Book{
        isbn: 9780525520047,
        title: "Killing Commendatore",
        year: 2018,
        summary: "In Killing Commendatore, a thirty-something portrait painter in Tokyo is abandoned by his wife and finds himself holed up in the mountain home of a famous artist, Tomohiko Amada. When he discovers a previously unseen painting in the attic, he unintentionally opens a circle of mysterious circumstances. To close it, he must complete a journey that involves a mysterious ringing bell, a two-foot-high physical manifestation of an Idea, a dapper businessman who lives across the valley, a precocious thirteen-year-old girl, a Nazi assassination attempt during World War II in Vienna, a pit in the woods behind the artist’s home, and an underworld haunted by Double Metaphors.",
        pages: 681,
        image: "https://contentcafe2.btol.com/ContentCafe/Jacket.aspx?&userID=CLOH21163&password=CC44366&Value=9780525520047&content=M&Return=1&Type=M"
      },
      %Book{
        isbn: 9780385352123,
        title: "Wind/Pinball",
        year: 2015,
        summary: "The debut short novels--nearly thirty years out of print-- by the internationally acclaimed writer, newly retranslated and in one English-language volume for the first time, with a new introduction by the author. These first major works of fiction by Haruki Murakami center on two young men--an unnamed narrator and his friend and former roommate, the Rat. Powerful, at times surreal, stories of loneliness, obsession, and eroticism, these novellas bear all the hallmarks of Murakami's later books, giving us a fascinating insight into a great writer's beginnings, and are remarkable works of fiction in their own right. Here too is an exclusive essay by Murakami in which he explores and explains his decision to become a writer. Prequels to the much-beloved classics A Wild Sheep Chase and Dance Dance Dance, these early works are essential reading for Murakami completists and contemporary fiction lovers alike",
        pages: 233,
        image: "https://contentcafe2.btol.com/ContentCafe/Jacket.aspx?&userID=CLOH21163&password=CC44366&Value=9780385352123&content=M&Return=1&Type=M"
      },
      %Book{
        isbn: 9781400043668,
        title: "Kafka on the Shore",
        year: 2006,
        summary: "Here we meet a teenage boy, Kafka Tamura, who is on the run, and Nakata, an aging simpleton who is drawn to Kafka for reasons that he cannot fathom. As their paths converge, acclaimed author Haruki Murakami enfolds readers in a world where cats talk, fish fall from the sky, and spirits slip out of their bodies to make love or commit murder, in what is a truly remarkable journey.",
        pages: 467,
        image: "https://contentcafe2.btol.com/ContentCafe/Jacket.aspx?&userID=CLOH21163&password=CC44366&Value=9781400043668&content=M&Return=1&Type=M"
      },
      %Book{
        isbn: 9780375704024,
        title: "Norwegian Wood",
        year: 2000,
        summary: "Toru, a quiet and preternaturally serious young college student in Tokyo, is devoted to Naoko, a beautiful and introspective young woman, but their mutual passion is marked by the tragic death of their best friend years before. Toru begins to adapt to campus life and the loneliness and isolation he faces there, but Naoko finds the pressures and responsibilities of life unbearable. As she retreats further into her own world, Toru finds himself reaching out to others and drawn to a fiercely independent and sexually liberated young woman.",
        pages: 296,
        image: "https://contentcafe2.btol.com/ContentCafe/Jacket.aspx?&userID=CLOH21163&password=CC44366&Value=9780375704024&content=M&Return=1&Type=M"
      },
      %Book{
        isbn: 9780385352109,
        title: "Colorless Tsukuru Tazaki and His Years of Pilgrimage",
        year: 2014,
        summary: "Haruki Murakami gives us the remarkable story of Tsukuru Tazaki, a young man haunted by a great loss; of dreams and nightmares that have unintended consequences for the world around us; and of a journey into the past that is necessary to mend the present. It is a story of love, friendship, and heartbreak for the ages.",
        pages: 386,
        image: "https://contentcafe2.btol.com/ContentCafe/Jacket.aspx?&userID=CLOH21163&password=CC44366&Value=9780385352109&content=M&Return=1&Type=M"
      },
      %Book{
        isbn: 9780375411694,
        title: "Sputnik Sweetheart",
        year: 2001,
        summary: "Part romance, part detective story, Sputnik Sweetheart tells the story of a tangled triangle of uniquely unrequited love. K is madly in love with his best friend, Sumire, but her devotion to a writerly life precludes her from any personal commitments. At least, that is, until she meets an older woman to whom she finds herself irresistibly drawn. When Sumire disappears from an island off the coast of Greece, K is solicited to join the search party—and finds himself drawn back into her world and beset by ominous visions. Subtle and haunting, Sputnik Sweetheart is a profound meditation on human longing.",
        pages: 210,
        image: "https://contentcafe2.btol.com/ContentCafe/Jacket.aspx?&userID=CLOH21163&password=CC44366&Value=9780375411694&content=M&Return=1&Type=M"
      },
      %Book{
        isbn: 9780375402517,
        title: "South of the Border, West of the Sun",
        year: 1999,
        summary: "South of the Border, West of the Sun is the beguiling story of a past rekindled, and one of Haruki Murakami’s most touching novels. Hajime has arrived at middle age with a loving family and an enviable career, yet he feels incomplete. When a childhood friend, now a beautiful woman, shows up with a secret from which she is unable to escape, the fault lines of doubt in Hajime’s quotidian existence begin to give way. Rich, mysterious, and quietly dazzling, in South of the Border, West of the Sun the simple arc of one man’s life becomes the exquisite literary terrain of Murakami’s remarkable genius.",
        pages: 213,
        image: "https://contentcafe2.btol.com/ContentCafe/Jacket.aspx?&userID=CLOH21163&password=CC44366&Value=9780375402517&content=M&Return=1&Type=M"
      },
      %Book{
        isbn: 9780307265838,
        title: "After Dark",
        year: 2007,
        summary: "Nineteen-year-old Mari is waiting out the night in an anonymous Denny’s when she meets a young man who insists he knows her older sister, thus setting her on an odyssey through the sleeping city. In the space of a single night, the lives of a diverse cast of Tokyo residents—models, prostitutes, mobsters, and musicians—collide in a world suspended between fantasy and reality. Utterly enchanting and infused with surrealism, After Dark is a thrilling account of the magical hours separating midnight from dawn.",
        pages: 191,
        image: "https://contentcafe2.btol.com/ContentCafe/Jacket.aspx?&userID=CLOH21163&password=CC44366&Value=9780307265838&content=M&Return=1&Type=M"
      },
      %Book{
        isbn: 9780451494627,
        title: "Men Without Women",
        year: 2017,
        summary: "A new collection of short stories--the first major new work of fiction from the beloved, internationally acclaimed, Haruki Murakami since his #1 best-selling Colorless Tsukuru Tazaki and His Years of Pilgrimage. Across seven tales, Haruki Murakami brings his powers of observation to bear on the lives of men who, in their own ways, find themselves alone. Here are vanishing cats and smoky bars, lonely hearts and mysterious women, baseball and the Beatles, woven together to tell stories that speak to us all",
        pages: 227,
        image: "https://contentcafe2.btol.com/ContentCafe/Jacket.aspx?&userID=CLOH21163&password=CC44366&Value=9780451494627&content=M&Return=1&Type=M"
      }
    ]
  }
)

genres = Metro.Repo.all(from g in Genre, where: g.id in [13, 1, 5])
         |> Metro.Repo.preload :books
books = from(b in Book, where: b.author_id == 1)
        |> Metro.Repo.all
        |> Metro.Repo.preload(:genres)

Enum.map(
  books,
  fn b ->
    Book.changeset(b, %{})
    |> Ecto.Changeset.put_assoc(:genres, genres)
    |> Metro.Repo.update!
  end
)


Metro.Repo.insert!(
  %Author{
    first_name: "Christopher",
    last_name: "Paolini",
    location: "USA",
    bio: "Christopher Paolini is the author of three other bestselling novels about Alagaësia: Inheritance is the fourth and final volume in the cycle. Christopher lives in Montana, where the natural landscape has been a major inspiration in the creation of his stories. You can find out more about Christopher and the Inheritance cycle at alagaesia.com.",
    books: [
      %Book{
        isbn: 9780375826689,
        title: "Eragon",
        year: 2003,
        summary: "In Alagaesia, a fifteen-year-old boy of unknown lineage called Eragon finds a mysterious stone that weaves his life into an intricate tapestry of destiny, magic, and power, peopled with dragons, elves, and monsters.",
        pages: 509,
        image: "https://contentcafe2.btol.com/ContentCafe/Jacket.aspx?&userID=CLOH21163&password=CC44366&Value=9780375826689&content=M&Return=1&Type=M"
      },
      %Book{
        isbn: 9780375826702,
        title: "Eldest",
        year: 2005,
        summary: "After successfully evading an Urgals ambush, Eragon is adopted into the Ingeitum clan and sent to finish his training so he can further help the Varden in their struggle against the Empire.",
        pages: 681,
        image: "https://contentcafe2.btol.com/ContentCafe/Jacket.aspx?&userID=CLOH21163&password=CC44366&Value=9780375826702&content=M&Return=1&Type=M"
      },
      %Book{
        isbn: 9780375926723,
        title: "Brisingr",
        year: 2008,
        summary: "The further adventures of Eragon and his dragon Saphira as they continue to aid the Varden in the struggle against the evil king, Galbatorix.",
        pages: 762,
        image: "https://contentcafe2.btol.com/ContentCafe/Jacket.aspx?&userID=CLOH21163&password=CC44366&Value=9780375926723&content=M&Return=1&Type=M"
      },
      %Book{
        isbn: 9780375856112,
        title: "Inheritance",
        year: 2011,
        summary: "The young Dragon Rider Eragon must finally confront the evil king Galbatorix to free Alaga©±sia from his rule once and for all. Conclusion to the series.",
        pages: 860,
        image: "https://contentcafe2.btol.com/ContentCafe/Jacket.aspx?&userID=CLOH21163&password=CC44366&Value=9780375856112&content=M&Return=1&Type=M"
      }
    ]
  }
)


genres = Metro.Repo.all(from g in Genre, where: g.id in [27, 4, 5, 20, 7])
         |> Metro.Repo.preload :books
books = from(b in Book, where: b.author_id == 2)
        |> Metro.Repo.all
        |> Metro.Repo.preload(:genres)

Enum.map(
  books,
  fn b ->
    Book.changeset(b, %{})
    |> Ecto.Changeset.put_assoc(:genres, genres)
    |> Metro.Repo.update!
  end
)

Metro.Repo.insert!(
  %Library{
    address: "3434 E Livingston Ave, Columbus, OH 43227, USA",
    image: "https://www.columbuslibrary.org/sites/default/files/uploads/images/Livingston.jpg",
    hours: "Mon-Thur: 9 a.m. - 9 p.m.",
    branch: "Columbus Metropolitan Library Livingston Branch",
    copies: [
      %Copy{
        isbn_id: 9780679446699,
        checked_out?: false
      },
      %Copy{
        isbn_id: 9780307593313,
        checked_out?: false
      },
      %Copy{
        isbn_id: 9780451494627,
        checked_out?: false
      }
    ],
    rooms: [
      %Room{
        capacity: 32,
        events: [
          %Event{
            start_time: ~N[2010-04-17 12:00:00],
            end_time: ~N[2010-04-17 14:00:00],
            description: "Read over the summer for strong reading skills all year long.",
            images: "https://www.columbuslibrary.org/sites/default/files/uploads/images/SRC-SignUpNowTile.jpg"
          }
        ]
      },
      %Room{
        capacity: 20,
        events: [
          %Event{
            start_time: ~N[2020-08-17 12:00:00],
            end_time: ~N[2020-08-17 14:00:00],
            description: "Columbus Metropolitan Library is committed to building a new, world-class library in Dublin.",
            images: "https://www.columbuslibrary.org/sites/default/files/uploads/images/DublinCampaign_homepage.jpg"
          }
        ]
      },
      %Room{
        capacity: 10,
        events: [
          %Event{
            start_time: ~N[2020-12-20 12:00:00],
            end_time: ~N[2020-12-20 14:00:00],
            description: "Read over the summer for strong reading skills all year long.",
            images: "https://www.columbuslibrary.org/sites/default/files/uploads/images/MayQuickPickEbooks.jpg"
          }
        ]
      }
    ]
  }
)

Metro.Repo.insert!(
  %Library{
    address: "96 S. Grant Avenue, Columbus, OH 43215 USA",
    image: "https://www.columbuslibrary.org/sites/default/files/uploads/images/Main_450x300.jpg",
    hours: "Mon-Thur: 9 a.m. - 9 p.m.",
    branch: "Main Library",
    copies: [
      %Copy{
        isbn_id: 9780375856112,
        checked_out?: false
      },
      %Copy{
        isbn_id: 9780525520047,
        checked_out?: false
      },
      %Copy{
        isbn_id: 9780385352123,
        checked_out?: false
      },
      %Copy{
        isbn_id: 9781400043668,
        checked_out?: false
      },
      %Copy{
        isbn_id: 9780375704024,
        checked_out?: false
      },
      %Copy{
        isbn_id: 9780385352109,
        checked_out?: false
      },
      %Copy{
        isbn_id: 9780375411694,
        checked_out?: false
      },
      %Copy{
        isbn_id: 9780375402517,
        checked_out?: false

      },
      %Copy{
        isbn_id: 9780307265838,
        checked_out?: false
      }
    ],
    rooms: [
      %Room{
        capacity: 32,
        events: [
          %Event{
            start_time: ~N[1969-07-14 12:00:00],
            end_time: ~N[1969-07-14 14:00:00],
            description: "Access central Ohio's digital history. Images, documents, maps and artifacts.",
            images: "https://www.columbuslibrary.org/sites/default/files/uploads/images/crp%26l-109%20cropped%203.jpg"
          }
        ]
      },

    ]
  }
)

Metro.Repo.insert!(
  %Library{
    address: "4445 E. Broad Street, Columbus, OH 43213",
    image: "https://www.columbuslibrary.org/sites/default/files/uploads/images/WhitehallBranch_451x300px.jpg",
    hours: "Mon-Thur: 9 a.m. - 9 p.m.",
    branch: "Whitehall",
    copies: [
      %Copy{
        isbn_id: 9780375926723,
        checked_out?: false
      },
      %Copy{
        isbn_id: 9780375826702,
        checked_out?: false
      },
      %Copy{
        isbn_id: 9780375826689,
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
    pending_notifications: 0,
    is_librarian?: true,
    card:
    %Card{
      pin: "0123"
    }
  }
)
