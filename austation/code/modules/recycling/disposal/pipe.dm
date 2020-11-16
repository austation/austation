/obj/structure/disposalpipe
	var/coilgun = FALSE // is this pipe part of a coilgun? Used for determining icon and if a coilgun projectile is allowed inside it

// coilgun uses the austation icon file
/*
/obj/structure/disposalpipe/Initialize()
	. = ..()
	var/holder
	if(coilgun)
		holder = "austation/[icon]"
		if(!text2path(holder))
			holder = "[icon]"
	else
		holder = "[icon]"
	icon = text2path(holder)
*/
