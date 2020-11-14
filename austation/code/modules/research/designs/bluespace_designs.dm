/////////////////////////////////////////
//////////////Bluespace//////////////////
/////////////////////////////////////////
/datum/design/bluespace_belt
	name = "Belt of Holding"
	desc = "An astonishingly complex belt popularized by a rich blue-space technology magnate."
	id = "bluespace_belt"
	build_type = PROTOLATHE
	materials = list(/datum/material/gold = 3000, /datum/material/diamond = 1500, /datum/material/uranium = 250, /datum/material/bluespace = 2000)
	build_path = /obj/item/storage/belt/bluespace
	category = list("Bluespace Designs")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/bluespace_Jar
	name = "Bluespace Jar"
	desc = "A jar used to contain creatures, using the power of bluespace."
	id = "bluespace_jar"
	build_type = PROTOLATHE
	build_path = /obj/item/bluespace_jar
	materials = list(/datum/material/glass = 3000, /datum/material/bluespace = 1200)
	category = list("Bluespace Designs")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

