/obj/machinery/atmospherics/components/trinary/filter/process_atmos()
	..()
	if(!on || !(nodes[1] && nodes[2] && nodes[3]) || !is_operational())
		return
	var/datum/gas_mixture/air1 = airs[1]
	var/datum/gas_mixture/air2 = airs[2]
	var/datum/gas_mixture/air3 = airs[3]
	var/input_starting_pressure = air1.return_pressure()
	if((input_starting_pressure < 0.01))
		return
	//Calculate necessary moles to transfer using PV=nRT
	var/transfer_ratio = transfer_rate/air1.return_volume()
	//Actually transfer the gas
	if(transfer_ratio > 0)

		if(filter_type && air2.return_pressure() <= 9000)
			if(filter_type in GLOB.gas_data.groups)
				air1.scrub_into(air2, transfer_ratio, GLOB.gas_data.groups[filter_type])
			else
				air1.scrub_into(air2, transfer_ratio, list(filter_type))
		if(air3.return_pressure() <= 9000)
			air1.transfer_ratio_to(air3, transfer_ratio)

	update_parents()


/obj/machinery/atmospherics/components/trinary/filter/ui_data()
	var/data = list()
	data["on"] = on
	data["rate"] = round(transfer_rate)
	data["max_rate"] = round(MAX_TRANSFER_RATE)
	data["filter_types"] = list()
	data["filter_types"] += list(list("name" = "Nothing", "id" = "", "selected" = !filter_type))
	for(var/id in GLOB.gas_data.ids)
		if(!(id in GLOB.gas_data.groups_by_gas))
			data["filter_types"] += list(list("name" = GLOB.gas_data.names[id], "id" = id, "selected" = (id == filter_type)))
	for(var/group in GLOB.gas_data.groups)
		data["filter_types"] += list(list("name" = group, "id" = group, "selected" = (group == filter_type)))
	return data
