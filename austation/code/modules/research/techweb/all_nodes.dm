/////////////////////////Bluespace tech/////////////////////////

/datum/techweb_node/unregulated_bluespace
	design_ids = list("desynchronizer", "bluespace_jar")

/////////////////////////Mining tech/////////////////////////

/datum/techweb_node/xpr_mining
	id = "xpr_mining"
	display_name = "Experimental Mining Technology"
	description = "Pushing the boundaries of what our mining equipment can do"
	prereq_ids = list("adv_mining")
	design_ids = list("mech_kinetic_accelerator", "hyperaoemod", "repeatermod", "resonatormod", "bountymod")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 1000)
	export_price = 5000
