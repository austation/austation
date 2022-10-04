#!/bin/bash
set -euo pipefail

#nb: must be bash to support shopt globstar
shopt -s globstar

st=0

if grep -El '^\".+\" = \(.+\)' _maps/**/*.dmm;	then
    echo "ERROR: Non-TGM formatted map detected. Please convert it using Map Merger!"
    st=1
fi;
if grep -P '^\ttag = \"icon' _maps/**/*.dmm;	then
    echo "ERROR: tag vars from icon state generation detected in maps, please remove them."
    st=1
fi;
if grep -P 'step_[xy]' _maps/**/*.dmm;	then
    echo "ERROR: step_x/step_y variables detected in maps, please remove them."
    st=1
fi;
if grep -m 1 'pixel_[xy] = 0' _maps/**/*.dmm;	then
    echo "ERROR: pixel_x/pixel_y = 0 variables detected in maps, please review to ensure they are not dirty varedits."
    st=1
fi;
if grep -P '\td[1-2] =' _maps/**/*.dmm;	then
    echo "ERROR: d1/d2 cable variables detected in maps, please remove them."
    st=1
fi;
<<<<<<< HEAD
echo "Checking for stacked cables"
if grep -P '"\w+" = \(\n([^)]+\n)*/obj/structure/cable,\n([^)]+\n)*/obj/structure/cable,\n([^)]+\n)*/area/.+\)' _maps/**/*.dmm;	then
    echo "found multiple cables on the same tile, please remove them."
    st=1
fi;
if grep '^/area/.+[\{]' _maps/**/*.dmm;	then
    echo "ERROR: Vareditted /area path use detected in maps, please replace with proper paths."
=======
echo -e "${BLUE}Checking for stacked cables...${NC}"
if grep -Pzo '"\w+" = \(\n[^)]*?/obj/structure/lattice[/\w]*?,\n[^)]*?/obj/structure/lattice[/\w]*?,\n[^)]*?/area/.+?\)' _maps/**/*.dmm;	then
	echo
    echo -e "${RED}ERROR: Found multiple lattices on the same tile, please remove them.${NC}"
    st=1
fi;
if grep -Pzo '"\w+" = \(\n[^)]*?/obj/structure/barricade(?<type>[/\w]*),\n[^)]*?/obj/structure/barricade\g{type},\n[^)]*?/area/.+\)' _maps/**/*.dmm;	then
	echo
    echo -e "${RED}ERROR: Found multiple identical barricades on the same tile, please remove them.${NC}"
    st=1
fi;
if grep -Pzo '"\w+" = \(\n[^)]*?/obj/structure/table(?<type>[/\w]*),\n[^)]*?/obj/structure/table\g{type},\n[^)]*?/area/.+\)' _maps/**/*.dmm;	then
	echo
    echo -e "${RED}ERROR: Found multiple identical tables on the same tile, please remove them.${NC}"
    st=1
fi;
if grep -Pzo '"\w+" = \(\n[^)]*?/obj/structure/chair(?<type>[/\w]*),\n[^)]*?/obj/structure/chair\g{type},\n[^)]*?/area/.+\)' _maps/**/*.dmm;	then
	echo
    echo -e "${RED}ERROR: Found multiple identical chairs on the same tile, please remove them.${NC}"
    st=1
fi;
if grep -Pzo '"\w+" = \(\n[^)]*?/obj/machinery/door/airlock[/\w]*?,\n[^)]*?/obj/machinery/door/airlock[/\w]*?,\n[^)]*?/area/.+\)' _maps/**/*.dmm;	then
	echo
    echo -e "${RED}ERROR: Found multiple airlocks on the same tile, please remove them.${NC}"
    st=1
fi;
if grep -Pzo '"\w+" = \(\n[^)]*?/obj/machinery/door/firedoor[/\w]*?,\n[^)]*?/obj/machinery/door/firedoor[/\w]*?,\n[^)]*?/area/.+\)' _maps/**/*.dmm;	then
	echo
    echo -e "${RED}ERROR: Found multiple firelocks on the same tile, please remove them.${NC}"
    st=1
fi;
if grep -Pzo '"\w+" = \(\n[^)]*?/obj/structure/closet(?<type>[/\w]*),\n[^)]*?/obj/structure/closet\g{type},\n[^)]*?/area/.+\)' _maps/**/*.dmm;	then
	echo
    echo -e "${RED}ERROR: Found multiple identical closets on the same tile, please remove them.${NC}"
    st=1
fi;
if grep -Pzo '"\w+" = \(\n[^)]*?/obj/structure/grille(?<type>[/\w]*),\n[^)]*?/obj/structure/grille\g{type},\n[^)]*?/area/.+\)' _maps/**/*.dmm;	then
	echo
    echo -e "${RED}ERROR: Found multiple identical grilles on the same tile, please remove them.${NC}"
    st=1
fi;
if grep -Pzo '"\w+" = \(\n[^)]*?/obj/structure/girder(?<type>[/\w]*),\n[^)]*?/obj/structure/girder\g{type},\n[^)]*?/area/.+\)' _maps/**/*.dmm;	then
	echo
    echo -e "${RED}ERROR: Found multiple identical girders on the same tile, please remove them.${NC}"
    st=1
fi;
if grep -Pzo '"\w+" = \(\n[^)]*?/obj/structure/stairs(?<type>[/\w]*),\n[^)]*?/obj/structure/stairs\g{type},\n[^)]*?/area/.+\)' _maps/**/*.dmm;	then
	echo
    echo -e "${RED}ERROR: Found multiple identical stairs on the same tile, please remove them.${NC}"
	st=1
fi;
if grep '^/area/.+[\{]' _maps/**/*.dmm;    then
    echo
    echo -e "${RED}ERROR: Variable editted /area path use detected in a map, please replace with a proper area path.${NC}"
>>>>>>> 71fa4206fa (Ports a pile of greps from TG (#7692))
    st=1
fi;
if grep -P '\W\/turf\s*[,\){]' _maps/**/*.dmm; then
    echo "ERROR: base /turf path use detected in maps, please replace with proper paths."
    st=1
fi;
if grep -P '^/*var/' code/**/*.dm; then
    echo "ERROR: Unmanaged global var use detected in code, please use the helpers."
    st=1
fi;
if grep -i 'centcomm' code/**/*.dm; then
    echo "ERROR: Misspelling(s) of CENTCOM detected in code, please remove the extra M(s)."
    st=1
fi;
if grep -i 'centcomm' _maps/**/*.dmm; then
    echo "ERROR: Misspelling(s) of CENTCOM detected in maps, please remove the extra M(s)."
    st=1
fi;
if grep -Pzo '"\w+" = \(\n[^)]*?/turf/[/\w]*?,\n[^)]*?/turf/[/\w]*?,\n[^)]*?/area/.+?\)' _maps/**/*.dmm; then
	echo
    echo -e "${RED}ERROR: Multiple turfs detected on the same tile! Please choose only one turf!${NC}"
    st=1
fi;
if grep -Pzo '"\w+" = \(\n[^)]*?/area/.+?,\n[^)]*?/area/.+?\)' _maps/**/*.dmm; then
	echo
    echo -e "${RED}ERROR: Multiple areas detected on the same tile! Please choose only one area!${NC}"
    st=1
fi;
if grep -Pzo '"\w+" = \(\n[^)]*?/obj/structure/lattice[/\w]*?,\n[^)]*?/turf/closed/wall[/\w]*?,\n[^)]*?/area/.+?\)' _maps/**/*.dmm;	then
	echo
    echo -e "${RED}ERROR: Found a lattice stacked with a wall, please remove them.${NC}"
    st=1
fi;
if grep -Pzo '"\w+" = \(\n[^)]*?/obj/structure/lattice[/\w]*?,\n[^)]*?/turf/closed[/\w]*?,\n[^)]*?/area/.+?\)' _maps/**/*.dmm;	then
	echo
    echo -e "${RED}ERROR: Found a lattice stacked within a wall, please remove them.${NC}"
    st=1
fi;
if grep -Pzo '"\w+" = \(\n[^)]*?/obj/structure/window[/\w]*?,\n[^)]*?/turf/closed[/\w]*?,\n[^)]*?/area/.+?\)' _maps/**/*.dmm;	then
	echo
    echo -e "${RED}ERROR: Found a window stacked within a wall, please remove it.${NC}"
    st=1
fi;
if grep -Pzo '"\w+" = \(\n[^)]*?/obj/machinery/door/airlock[/\w]*?,\n[^)]*?/turf/closed[/\w]*?,\n[^)]*?/area/.+?\)' _maps/**/*.dmm;	then
	echo
    echo -e "${RED}ERROR: Found an airlock stacked within a wall, please remove it.${NC}"
    st=1
fi;
if grep -Pzo '"\w+" = \(\n[^)]*?/obj/structure/stairs[/\w]*?,\n[^)]*?/turf/open/genturf[/\w]*?,\n[^)]*?/area/.+?\)' _maps/**/*.dmm;	then
	echo
    echo -e "${RED}ERROR: Found a staircase on top of a gen_turf. Please replace the gen_turf with a proper turf.${NC}"
    st=1
fi;
if grep -Pzo '/obj/machinery/conveyor/inverted[/\w]*?\{\n[^}]*?dir = [1248];[^}]*?\},?\n' _maps/**/*.dmm;	then
	echo
    echo -e "${RED}ERROR: Found an inverted conveyor belt with a cardinal dir. Please replace it with a normal conveyor belt.${NC}"
    st=1
fi;
if ls _maps/*.json | grep -P "[A-Z]"; then
    echo "ERROR: Uppercase in a map json detected, these must be all lowercase."
    st=1
fi;
for json in _maps/*.json
do
	filepath="_maps/$(jq -r '.map_path' $json)"
	filenames=$(jq -r '.map_file' $json)
	if [[ "$filenames" =~ ^\[ ]] # If it starts with brackets it's a list
	then
		echo "$filenames" | jq -c '.[]' | while read filename
		do
			#Remove quotes
			filename="${filename%\"}"
			filename="${filename#\"}"

			if [ ! -f "$filepath/$filename" ]
			then
				echo "WARNING: Found potential invalid file reference to $filepath/$filename in _maps/$json"
				st=1
			fi
		done
	else # It's not a list, it's just one file name
		if [ ! -f "$filepath/$filenames" ]
		then
			echo "WARNING: Found potential invalid file reference to $filepath/$filenames in _maps/$json"
			st=1
		fi
	fi
done
echo "Checking for missing newlines"
nl='
'
nl=$'\n'
while read f; do
    t=$(tail -c2 "$f"; printf x); r1="${nl}$"; r2="${nl}${r1}"
    if [[ ! ${t%x} =~ $r1 ]]; then
        echo "file $f is missing a trailing newline"
        st=1
    fi;
done < <(find . -type f -not \( -path "./.git/*" -prune \) -exec grep -Iq . {} \; -print)
exit $st
