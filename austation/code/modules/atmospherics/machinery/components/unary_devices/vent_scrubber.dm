
/obj/machinery/atmospherics/components/unary/vent_scrubber
	var/list/clean_filter_types = null

/obj/machinery/atmospherics/components/unary/vent_scrubber/proc/generate_clean_filter_types()
	clean_filter_types = list()
	for(var/id in filter_types)
		if(id in GLOB.gas_data.groups)
			clean_filter_types += GLOB.gas_data.groups[id]
		else
			clean_filter_types += id

/obj/machinery/atmospherics/components/unary/vent_scrubber/broadcast_status()
	if(!radio_connection)
		return FALSE

	var/list/f_types = list()
	for(var/id in GLOB.gas_data.ids)
		if(!(id in GLOB.gas_data.groups_by_gas))
			f_types += list(list("gas_id" = id, "gas_name" = GLOB.gas_data.names[id], "enabled" = (id in filter_types)))

	for(var/group in GLOB.gas_data.groups)
		f_types += list(list("gas_id" = group, "gas_name" = group, "enabled" = (group in filter_types)))

	var/datum/signal/signal = new(list(
		"tag" = id_tag,
		"frequency" = frequency,
		"device" = "VS",
		"timestamp" = world.time,
		"power" = on,
		"scrubbing" = scrubbing,
		"widenet" = widenet,
		"filter_types" = f_types,
		"sigtype" = "status"
	))

	var/area/A = get_area(src)
	if(!A.air_scrub_names[id_tag])
		name = "\improper [A.name] air scrubber #[A.air_scrub_names.len + 1]"
		A.air_scrub_names[id_tag] = name

	A.air_scrub_info[id_tag] = signal.data
	radio_connection.post_signal(src, signal, radio_filter_out)

	return TRUE
