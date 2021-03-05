// Austation Code to allow adding new techweb designs without editing core code
/datum/techweb_node
	var/list/austation_design_ids = list()
	var/list/austation_design_ids_remove = list()

/datum/techweb_node/Initialize()
	design_ids -= austation_design_ids_remove
	design_ids += austation_design_ids
	..()
