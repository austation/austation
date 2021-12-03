/datum/design/mech_kinetic_accelerator
	name = "MKA-27 Mech Kinetic Accelerator"
	desc = "The result of many complaints from disgruntled miners and equally as many complaints from disgruntled roboticists of the lack of reliable ways to combat lavaland megaphauna. The MKA-27 was produced by a team of NT scientists and hacked into the protolathe databases. Although never approved by central command, few can argue against the costs the MKA-27 saves compared to constantly rebuilding mechs and hiring new miners."
	id = "mech_kinetic_accelerator"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/kinetic_accelerator
	materials = list(/datum/material/iron=30000,/datum/material/gold=20000,/datum/material/plasma=25000,/datum/material/silver=20000)
	construction_time = 600
	category = list("Exosuit Equipment")

/datum/design/mech_ion_thrusters
	name = "Exosuit Module (Ion Thruster Package)"
	desc = "A thruster package for exosuits. Uses energy to excite ions thus creating some propulsion for a lot of power."
	id = "mech_ion_thrusters"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_equipment/thrusters/ion
	materials = list(/datum/material/iron=25000,/datum/material/titanium=10000,/datum/material/gold=5000,/datum/material/plasma=10000)
	construction_time = 500
	category = list("Exosuit Equipment")

/datum/design/atv_bike
	name = "All Terrain Vehicle"
	desc = "A quad bike for traversing uneven terrain effortlessly."
	id = "print_atv"
	build_type = MECHFAB
	build_path = /obj/vehicle/ridden/atv
	materials = list(/datum/material/titanium=3000,/datum/material/plastic=1000,/datum/material/iron=2000)
	construction_time = 500
	category = list("Misc")
