/obj/machinery/telecomms/server
	var/list/filter_entries = list()

/datum/comm_filter_entry
	var/filter_text = ""
	var/trigger = ""
	var/target = ""
	var/output = ""

/obj/machinery/telecomms/server/receive_information(datum/signal/subspace/vocal/signal, obj/machinery/telecomms/machine_from)
	// can't log non-vocal signals
	if(!istype(signal) || !signal.data["message"] || !is_freq_listening(signal))
		return

	if(traffic > 0)
		totaltraffic += traffic // add current traffic to total traffic

	// Delete particularly old logs
	if (log_entries.len >= 400)
		log_entries.Cut(1, 2)

	var/datum/comm_log_entry/log = new
	log.parameters["mobtype"] = signal.virt.source.type
	log.parameters["name"] = signal.data["name"]
	log.parameters["job"] = signal.data["job"]
	log.parameters["message"] = signal.data["message"]
	log.parameters["language"] = signal.language

	// If the signal is still compressed, make the log entry gibberish
	var/compression = signal.data["compression"]
	if(compression > 0)
		log.input_type = "Corrupt File"
		var/replace_characters = compression >= 20 ? TRUE : FALSE
		log.parameters["name"] = Gibberish(signal.data["name"], replace_characters)
		log.parameters["job"] = Gibberish(signal.data["job"], replace_characters)
		log.parameters["message"] = Gibberish(signal.data["message"], replace_characters)

	// Give the log a name and store it
	var/identifier = num2text( rand(-1000,1000) + world.time )
	log.name = "data packet ([rustg_hash_string(RUSTG_HASH_MD5, identifier)])"
	log_entries.Add(log)

	// austation begin -- apply filter to messages
	if(filter_entries)
		for(var/datum/comm_filter_entry/F in filter_entries)
			var/message = signal.data["message"]
			var/regex/R1 = new("[F.trigger]","i")
			R1.Find(message)
			if(R1.match)
				if(F.output == "/d")
					return
				F.output = replacetext(F.output,"/d","")
				var/regex/R2 = new("[F.target]","ig")	// if the target ends with .* the full stop at the end of the message will be eaten
				message = capitalize(R2.Replace(message,F.output))
				if(findlasttext(message,".") == 0)
					message = addtext(message,".")
				signal.data["message"] = message
	// austation end

	var/can_send = relay_information(signal, /obj/machinery/telecomms/hub)
	if(!can_send)
		relay_information(signal, /obj/machinery/telecomms/broadcaster)
