/////////////////////////////////////////
//////////////Bluespace//////////////////
/////////////////////////////////////////
/datum/design/bluespace_belt
	name = "Belt of Holding"
	desc = "An astonishingly complex belt popularized by a rich blue-space technology magnate."
	id = "bluespace_belt"
	req_tech = list("bluespace" = 7, "materials" = 5, "engineering" = 5, "plasmatech" = 6)
	build_type = PROTOLATHE
	materials = list(MAT_GOLD = 1500, MAT_DIAMOND = 3000, MAT_URANIUM = 1000)
	build_path = /obj/item/storage/belt/bluespace
	category = list("Bluespace")
