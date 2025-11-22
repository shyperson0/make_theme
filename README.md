# make_theme.sh
Dependencias: [ani2png-rs](https://github.com/fvckgrimm/ani2png-rs), awk, grep, xcursorgen, magick and dd(don't ask)

It's very manual atm, so bear w m for a sec.
- edit the THEME_NAME variable to whatever
- edit the `declare -A MAP=(...)` statement with relevant `["windows ani file w/o extension"]="equivalentxcursor"` lines, according to the names in the windows theme u got
- drink watr
- edit the links @ the bottom to fill in any cursors the theme might not have but your programs might expect
Rn it won't emit a theme index, tho it's literally just three lines of metadata u can write urself such as:

```
[Icon Theme]
Name=Sae Cursor
Comment=Sae Saotome's members-only cursor theme
```

and save it as $THEME_NAME/index.theme

included mappings and links are intended for Sae Saotome's membership cursor, which is the sole reason for me making ts
u can just copy the $THEME_NAME folder to wherever ur icon themes are (like ~/.icons or /usr/share/icons or u should if it's SOMEHOW neither of those)
