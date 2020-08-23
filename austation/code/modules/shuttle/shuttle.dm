/obj/docking_port/stationary/proc/load_roundstart()
	if(json_key)
		var/sid = SSmapping.config.shuttles[json_key]
		roundstart_template = SSmapping.shuttle_templates[sid]
		if(!roundstart_template)
			CRASH("json_key:[json_key] value \[[sid]\] resulted in a null shuttle template for [src]")
	else if(roundstart_template) // passed a PATH
		var/sid = "[initial(roundstart_template.port_id)]_[initial(roundstart_template.suffix)]"

		roundstart_template = SSmapping.shuttle_templates[sid]
		if(!roundstart_template)
			CRASH("Invalid path ([sid]/[roundstart_template]) passed to docking port.")

	if(roundstart_template)
		SSshuttle.action_load(roundstart_template, src)
