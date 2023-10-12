// Always return 0 cost for techweb discovery point cost, effectively disabling the system
/datum/techweb_node/calculate_discovery_cost(their_tier)
	return 0
