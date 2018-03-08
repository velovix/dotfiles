#!/bin/sh

B='#00000044'  # blank
C='#ffffff22'  # clear ish
D='#236E86CC'  # default
T='#52B0BBbb'  # text
W='#52B0BBbb'  # wrong
V='#52B0BBbb'  # verifying

i3lock \
	--insidevercolor=$C   \
	--ringvercolor=$V     \
	\
	--insidewrongcolor=$C \
	--ringwrongcolor=$W   \
	\
	--insidecolor=$B      \
	--ringcolor=$D        \
	--linecolor=$B        \
	--separatorcolor=$D   \
	\
	--verifcolor=$T        \
	--wrongcolor=$T        \
	--timecolor=$T        \
	--datecolor=$T        \
	--layoutcolor=$T      \
	--keyhlcolor=$W       \
	--bshlcolor=$W        \
	\
	--blur 10             \
	--clock               \
	--indicator           \
	--timestr="%H:%M:%S"  \
	--datestr="%A, %m %Y" \
	--keylayout 2         \

	# --veriftext="Drinking verification can..."
	# --wrongtext="Nope!"
	# --textsize=20
	# --modsize=10
	# --timefont=comic-sans
	# --datefont=monofur
	# etc
