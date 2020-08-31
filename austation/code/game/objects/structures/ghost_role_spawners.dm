//Objects that spawn ghosts in as a certain role when they click on it, i.e. away mission bartenders.

//Reclusive scientists that were too busy working on their own experiments to notice the shuttle call and were left behind.  Now they have fled to lavaland to continue their powergaming ways for the foreseeable future
/obj/effect/mob_spawn/human/autist
	name = "reclusive sleeper"
	desc = "A hig-tech bed with many personal customisations.  It offers a shelter from which the outside world can not disturb your thoughts."
	mob_name = "a recluse"
	icon = 'icons/obj/lavaland/spawners.dmi'
	icon_state = "terrarium"
	density = TRUE
	roundstart = FALSE
	death = FALSE
	mob_species = /datum/species/human
	outfit = /datum/outfit/autist
	short_desc = "You were left behind during the shuttle call."
	flavour_text = "The station was doomed and many were dying or dead all around, \
	some made it to the escape shuttles and pods but you were too busy working on your own projects to notice. \
	Luckily the mining shuttle was still operational, so you gathered as much of your work as possible and set out for a new life on lavaland. \
	Your employee records have been expunged, so don't be surprised if your fellow NT employees do not recognise you."
	assignedrole = "Autist"

/obj/effect/mob_spawn/human/autist/Destroy()
	return ..()

/datum/outfit/autist
	name = "Autist"
	uniform = /obj/item/clothing/under/color/grey
	head = /obj/item/clothing/head/soft/grey
	mask = /obj/item/clothing/mask/breath
	shoes = /obj/item/clothing/shoes/sneakers/brown
	r_pocket = /obj/item/tank/internals/emergency_oxygen
