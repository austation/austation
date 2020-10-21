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

////////////////////////Medical tech//////////////////////////
/datum/techweb_node/eso_augments
	id = "eso_augments"
	display_name = "Esoteric Cybernetic Organs"
	description = "These organs operate on what most scientists would agree is pure pseudoscience"
	prereq_ids = list("cyber_organs_upgraded", "micro_bluespace, adv_cyber_implants")
	design_ids = list("eso_stomach", "eso_heart", "eso_lungs", "eso_ears", "eso_liver")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 1000)
	export_price = 7500
