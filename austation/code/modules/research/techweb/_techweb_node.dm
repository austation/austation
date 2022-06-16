// Austation Code to allow adding new techweb designs without editing core code
/datum/techweb_node
	var/list/austation_design_ids = list()
	var/list/austation_design_ids_remove = list()

/datum/techweb_node/Initialize(mapload)
	design_ids -= austation_design_ids_remove
	design_ids += austation_design_ids
	..()

/datum/techweb_node/calculate_discovery_cost(their_tier)
	return 0
