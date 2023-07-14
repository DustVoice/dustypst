#import "langs.typ"
#import "dustypst.typ"

#let default_lang = langs.de

#let pkgtable(core: "", extra: "", /*community: "",*/ aur: "", multilib: "", groups: "") = pkgtable_(lang: default_lang, core: "", extra: "", /*community: "",*/ aur: "", multilib: "", groups: "")
#let note(content) = dustypst.note(lang: default_lang, content)
#let tip(content) = dustypst.tip(lang: default_lang, content)
#let important(content) = dustypst.important(lang: default_lang, content)
#let warning(content) = dustypst.warning(lang: default_lang, content)
#let caution(content) = dustypst.caution(lang: default_lang, content)