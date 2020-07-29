/datum/techweb_node/accelerator_tech // Might also put a mech-mounted pneumatic cannon under this tech too, sometime
	id = "accelerator_tech"
	display_name = "Accelerator Technology"
	description = "Making things move fast just got faster."
	prereq_ids = list("adv_mecha", "adv_mining", "weaponry")
	design_ids = list("mech_kinetic_accelerator", "mech_ion_thrusters")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)
	export_price = 5000