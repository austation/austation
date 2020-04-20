/obj/item/circuitboard/computer/admin_bus
	build_path = /obj/machinery/computer/shuttle/admin_bus

/obj/machinery/computer/shuttle/admin_bus
	name = "Admin Bus Console"
	desc = "Used to control the Admin Bus."
	circuit = /obj/item/circuitboard/computer/admin_bus
	req_access = list(ACCESS_CENT_GENERAL)
	shuttleId = "adminbus"
	possible_destinations = "whiteship_away;whiteship_home;whiteship_lavaland;whiteship_z4;caravansyndicate1_listeningpost;syndielavaland_cargo;emergency_home;syndicate_nw;adminbus_custom"

/obj/machinery/computer/camera_advanced/shuttle_docker/admin_bus
	name = "Admin Bus Navigation Computer"
	desc = "Used to designate a precise transit location for the Admin Bus."
	shuttleId = "adminbus"
	lock_override = NONE
	shuttlePortId = "adminbus_custom"
	view_range = 14
	jumpto_ports = list("whiteship_away" = 1, "whiteship_home" = 1, "whiteship_lavaland" = 1, "whiteship_z4" = 1, "caravansyndicate1_listeningpost" = 1, "syndielavaland_cargo" = 1, "emergency_home" = 1, "syndicate_nw" = 1)
	whitelist_turfs = list(/turf/open/space,
		/turf/open/floor/plating,
		/turf/open/lava,
		/turf/open/floor/plating/beach,
		/turf/open/floor/plating/ashplanet,
		/turf/open/floor/plating/asteroid,
		/turf/open/floor/plating/lavaland_baseturf)
