/datum/design/borg_transform_security
	name = "Cyborg Upgrade (Security Module)"
	id = "borg_transform_security"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/transform/security
	materials = list(/datum/material/iron = 15000, /datum/material/glass = 15000, /datum/material/diamond = 1500, /datum/material/gold = 2000, /datum/material/uranium = 1000)
	construction_time = 120
	category = list("Cyborg Upgrade Modules")

/datum/design/borg/kitchen
	name = "Cyborg Upgrade (Service)"
	id = "borg_upgrade_cooking"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/kitchen
	materials = list(/datum/material/iron = 10000, /datum/material/glass = 4000)
	construction_time = 100
	category = list("Cyborg Upgrade Modules")

//Gygax
/datum/design/gygax_chassis
	name = "Exosuit Chassis (\"Gygax\")"
	id = "gygax_chassis"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/chassis/gygax
	materials = list(/datum/material/iron=20000)
	construction_time = 100
	category = list("Gygax")

/datum/design/gygax_torso
	name = "Exosuit Torso (\"Gygax\")"
	id = "gygax_torso"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/gygax_torso
	materials = list(/datum/material/iron=20000,/datum/material/glass = 10000,/datum/material/gold=2000,/datum/material/silver=2000)
	construction_time = 300
	category = list("Gygax")

/datum/design/gygax_head
	name = "Exosuit Head (\"Gygax\")"
	id = "gygax_head"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/gygax_head
	materials = list(/datum/material/iron=10000,/datum/material/glass = 5000, /datum/material/gold=2000,/datum/material/silver=2000)
	construction_time = 200
	category = list("Gygax")

/datum/design/gygax_left_arm
	name = "Exosuit Left Arm (\"Gygax\")"
	id = "gygax_left_arm"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/gygax_left_arm
	materials = list(/datum/material/iron=15000, /datum/material/gold=1000,/datum/material/silver=1000)
	construction_time = 200
	category = list("Gygax")

/datum/design/gygax_right_arm
	name = "Exosuit Right Arm (\"Gygax\")"
	id = "gygax_right_arm"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/gygax_right_arm
	materials = list(/datum/material/iron=15000, /datum/material/gold=1000,/datum/material/silver=1000)
	construction_time = 200
	category = list("Gygax")

/datum/design/gygax_left_leg
	name = "Exosuit Left Leg (\"Gygax\")"
	id = "gygax_left_leg"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/gygax_left_leg
	materials = list(/datum/material/iron=15000, /datum/material/gold=2000,/datum/material/silver=2000)
	construction_time = 200
	category = list("Gygax")

/datum/design/gygax_right_leg
	name = "Exosuit Right Leg (\"Gygax\")"
	id = "gygax_right_leg"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/gygax_right_leg
	materials = list(/datum/material/iron=15000, /datum/material/gold=2000,/datum/material/silver=2000)
	construction_time = 200
	category = list("Gygax")

/datum/design/gygax_armor
	name = "Exosuit Armor (\"Gygax\")"
	id = "gygax_armor"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/part/gygax_armor
	materials = list(/datum/material/iron=15000,/datum/material/gold=10000,/datum/material/silver=10000,/datum/material/titanium=10000)
	construction_time = 600
	category = list("Gygax")


/datum/design/drone_shell
	name = "Drone Shell"
	desc = "A shell of a maintenance drone, an expendable robot built to perform station repairs.."
	id = "drone_shell"
	build_type = MECHFAB
	build_path = /obj/item/drone_shell
	materials = list(/datum/material/iron=2000,/datum/material/gold=200,/datum/material/glass=1500)
	construction_time = 100
	category = list("Misc")
