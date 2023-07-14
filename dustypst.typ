#import "langs.typ": default_lang

#let default_font = (
  name: "Inter",
  name_raw: "JetBrains Mono",
  size: 13pt,
)

#let dustvoice_author = (name: "DustVoice", email: "info@dustvoice.de", affiliation: none, phone: none)

#let dracula = (
  colors: (
    background: rgb("#282a36"),
    selection: rgb("#44475a"),
    foreground: rgb("#f8f8f2"),
    comment: rgb("#6272a4"),
    cyan: rgb("#8be9fd"),
    green: rgb("#50fa7b"),
    orange: rgb("#ffb86c"),
    pink: rgb("#ff79c6"),
    purple: rgb("#bd93f9"),
    red: rgb("#ff5555"),
    yellow: rgb("#f1fa8c"),
  ),
)

#let cont2str(content) = {
  if type(content) == "content" and content.has("text") {
    content.text
  } else if type(content) == "string" {
    content
  } else {
    ""
  }
}

#let str2color(color) = {
  if type(color) == "string" {
    rgb(color)
  } else if type(color) == "color" {
    color
  }
}

#let border-block(width: 100%, color, content) = block(
  align(left, content),
  stroke: .25em + str2color(color),
  inset: 1em,
  radius: .5em,
  width: width
)
#let fill-block(width: 100%, color, content) = block(
  align(left, content),
  fill: str2color(color),
  inset: 1em,
  radius: .5em,
  width: width,
)
#let border-box(width: auto, color, content) = box(
  content,
  stroke: scale * .25em + str2color(color),
  outset: scale * .25em,
  radius: scale * .25em,
  inset: (x: lr_inset, y: tb_inset),
  width: width,
)
#let fill-box(width: auto, color, content) = box(
  content,
  fill: str2color(color),
  inset: (left: .25em, right: .25em, top: .25em),
  outset: (bottom: .25em),
  radius: .25em,
  width: width,
)

#let colorbox(title: "title", title_color: none, color: black, textcolor: white, content) = {
  return box(
    fill: none,
    stroke: .25em + color,
    radius: .5em,
    width: 100%,
    clip: false
  )[
    #if title != "" {
      [
        #box(
          fill: if title_color != none { title_color } else { color },
          inset: (left: 1em, top: .5em, right: 1em, bottom: .5em),
          radius: (top-left: .5em, bottom-right: .5em),
        )[
          #text(fill: textcolor, weight: "bold")[#title]
        ]\
      ]
    } else {
      rect(
        fill: str2color(color),
        width: 100%,
        height: 2em,
      )
    }
    #box(
      width: 100%,
      inset: (x: 1em, bottom: 1em)
    )[
      #content
    ]
  ]
}

#let code(root: false, lang: "", content) = {
  let text_content = [
    #if root {
      emoji.key + h(.2em)
    }
    #raw(
      lang: lang,
      block: false,
      cont2str(content)
    )
  ]

  fill-box(
    dracula.colors.yellow,
    text_content
  )
}

#let cmd(root: false, content) = code(root: root, lang: "fish", content)
#let cmd-root(content) = cmd(root: true, content)

#let linkfn(plain: false, color: dracula.colors.green, dest, body) = {
  let link_markup = [
    #link(dest, body)#footnote(link(dest, dest))
  ]

  if plain {
    link_markup
  } else {
    fill-box(color, link_markup)
  }
}

#let filepath(content) = fill-box(dracula.colors.cyan, raw(cont2str(content)))

#let filesrc(readonly: false, exec: false, perm: false, part: false, filename, content) = {
  let title = [
    #let add_space = false
    #if readonly {
      emoji.lock
      add_space = true
    }
    #if exec {
      emoji.joystick
      add_space = true
    }
    #if perm {
      emoji.key
      add_space = true
    }
    #if add_space {
      h(.5em)
    }
    #raw(filename)
    #if part {
      h(.5em) + sym.dots
    }
  ]

  colorbox(title: text(weight: "regular", title), color: dracula.colors.cyan, textcolor: black, content)
}

#let pkg-target(aur: false, name) = {
 if aur {
    return "https://aur.archlinux.org/packages/" + name
  } else {
    return "https://archlinux.org/packages/" + name
  }
}

#let pkg-link(target: "", plain: false, nofn: false, aur: false, name) = {
  if target == "" {
    target = pkg-target(aur: aur, name)
  }

  let link_function(target, content) = if nofn {
    link(target, content)
  } else {
    linkfn(color: dracula.colors.orange, target, content)
  }

  if plain {
    link_function(target, name)
  } else {
    if aur {
      link_function(target)[#raw(name)#sub(raw("AUR"))]
    } else {
      link_function(target, raw(name))
    }
  }
}

#let pkg(name) = pkg-link(name)
#let pkg-aur(name) = pkg-link(aur: true, name)

// IMPORTANT: The community repository was recently merged into extra!
#let pkgtable(lang: default_lang, core: "", extra: "", /*community: "",*/ aur: "", multilib: "", groups: "") = {
  colorbox(title: lang.packages, color: dracula.colors.orange,
    text(size: .75em, fill: dracula.colors.selection,
      for repo in (
        ("Core", "https://archlinux.org/packages/?repo=Core", core),
        ("Extra", "https://archlinux.org/packages/?repo=Extra", extra),
        //("Community", "https://archlinux.org/packages/?repo=Community", community),
        ("Multilib", "https://archlinux.org/packages/?repo=Multilib", multilib),
        ("AUR", "https://aur.archlinux.org/packages", aur),
        ("Groups", "https://archlinux.org/groups/", groups),
      ) {
        if repo.at(2).len() > 0 {
          [
            / #repo.at(0): #link(repo.at(1), emoji.chain)\ #{
              repo.at(2).split(" ").map(pkg => {
                pkg-link(plain: true, nofn: true, aur: repo.at(0) == "AUR", pkg)
              }).join(" " + sym.hyph.point + " ")
            }
          ]
        }
      }
    )
  )
}

#let note(lang: default_lang, content) = colorbox(
  title: lang.note,
  color: dracula.colors.comment,
  content
)
#let tip(lang: default_lang, content) = colorbox(
  title: lang.tip,
  color: dracula.colors.purple,
  content
)
#let important(lang: default_lang, content) = colorbox(
  title: lang.important,
  color: dracula.colors.pink,
  content
)
#let warning(lang: default_lang, content) = colorbox(
  title: lang.warning, 
  color: dracula.colors.red, 
  content
)
#let caution(lang: default_lang, content) = colorbox(
  title: lang.caution,
  color: dracula.colors.background,
  content
)

#let codeblock(content) = colorbox(title: "", color: dracula.colors.yellow, content)

#let terminal(windows: false, lang: "fish", root: false, path, raw_content) = {
  if windows {
    lang = "cmd"
  }
  
  let format(content) = {
    raw(lang: lang, cont2str(content))
  }

  let content = {
    let children = {
      if raw_content.has("children") {
        for child in raw_content.children {
          format(child)
        }
      } else {
        format(raw_content)
      }
    }

    children
  }

  let title = [
    #if windows {
      emoji.window
    }
    #if root {
      emoji.key + h(1em)
    }
    #path
  ]

  colorbox(
    title: text(
      weight: "regular",
      size: .75em,
      title
    ),
    color: dracula.colors.yellow,
    textcolor: black,
    content
  )
}
#let terminal-root(windows: false, lang: "fish", path, content) = terminal(windows: windows, lang: lang, root: true, path, content)

#let admindoc_project(
  title: none,
  subtitle: none,
  authors: (dustvoice_author,),
  font: default_font,
  lang: default_lang,
  outlined: true,
  body,
) = {
  set text(font: font.name, size: font.size, lang: lang.lang)
  
  show raw: set text(font: font.name_raw)

  set document(author: authors.map(a => a.name), title: title)

  set page(
    paper: "a5",
    header: [
      #counter(footnote).update(0)
      #align(
        center,
        block(spacing: 0pt)[
          #if (title != none) {[
            #text(1em, fill: dracula.colors.pink, title)\
          ]}
          #if (subtitle != none) {[
            #text(0.5em, fill: dracula.colors.purple, subtitle)
          ]}
        ]
      )
    ],
    numbering: none
  )

  show outline.entry: it => {[
    #link(it.element.location(), it.body)#box(width: 1fr, repeat[#h(.25em)#sym.dot])
  ]}

  if outlined {
    outline(title: lang.outline, indent: none)
  }  
  
  set par(justify: true)
  
  set figure(numbering: "1")
  
  set heading(numbering: "1.1")
  
  show heading: heading => {
    pagebreak()
    text(1.25em, heading)
  }
  
  body
}

#let userdoc_project(
  title: none,
  authors: (dustvoice_author,),
  date: datetime.today().display("[day].[month].[year]"),
  logo: none,
  font: default_font,
  lang: default_lang,
  outlined: true,
  body,
) = {
  set document(author: authors.map(a => a.name), title: title)
  
  set page(numbering: "1", number-align: center)
  
  set text(font: font.name, size: font.size, lang: lang.lang)
  
  show raw: set text(font: font.name_raw)

  set heading(numbering: "1.1")

  v(0.6fr)
  if logo != none {
    align(right, image(logo, width: 26%))
  }
  v(9.6fr)

  text(1.1em, date)
  v(1.2em, weak: true)
  text(2em, weight: 700, title)

  pad(
    top: 0.7em,
    right: 20%,
    grid(
      columns: (1fr,) * calc.min(3, authors.len()),
      gutter: 1em,
      ..authors.map(author => align(start)[
        *#author.name* \
        #author.email \
        #author.affiliation \
        #author.phone
      ]),
    ),
  )

  v(2.4fr)
  pagebreak()

  set par(justify: true)

  if outlined {
    outline(title: lang.outline)
    pagebreak()
  }
  
  body
}