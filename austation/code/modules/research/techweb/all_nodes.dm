/////////////////////////Bluespace tech/////////////////////////

/datum/techweb_node/unregulated_bluespace
	design_ids = list("desynchronizer", "bluespace_jar")

/////////////////////////Mining tech/////////////////////////

	/datum/techweb_node/adv_mining
		id = "adv_mining"
		display_name = "Advanced Mining Technology"
		description = "Efficiency Level 127"	//dumb mc references
		prereq_ids = list("basic_mining", "adv_engi", "adv_power", "adv_plasma")
		design_ids = list("drill_diamond", "jackhammer", "plasmacutter_adv", "mech_kinetic_accelerator", "hypermod", "hyperaoemod", "repeatermod", "resonatormod", "bountymod")
		research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)
		export_price = 5000
