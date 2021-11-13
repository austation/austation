/obj/item/disk/tech_disk/research/Initialize()
	. = ..()

	if(node_id)
		var/datum/techweb/techweb_datum = new /datum/techweb
		var/datum/techweb_node/node = SSresearch.techweb_node_by_id(node_id)

		techweb_datum.researched_nodes = list()
		techweb_datum.research_node(node, TRUE, FALSE, FALSE)
		stored_research = techweb_datum
