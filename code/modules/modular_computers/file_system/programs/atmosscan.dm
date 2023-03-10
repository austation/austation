/datum/computer_file/program/atmosscan
	filename = "atmosscan"
	filedesc = "Atmospheric Scanner"
	program_icon_state = "air"
	extended_desc = "A small built-in sensor reads out the atmospheric conditions around the device."
	network_destination = "atmos scan"
	size = 4
	tgui_id = "NtosAtmos"



/datum/computer_file/program/atmosscan/ui_data(mob/user)
	var/list/data = list()
	var/list/airlist = list()
<<<<<<< HEAD
	var/turf/T = get_turf(ui_host())
	if(T)
=======
	var/turf/T = get_turf(computer.ui_host())
	var/obj/item/computer_hardware/sensorpackage/sensors = computer?.get_modular_computer_part(MC_SENSORS)
	if(T && sensors?.check_functionality())
>>>>>>> d1bf5ad2ab (ModPCs use the same TGUI window + ModPC fixes (#8639))
		var/datum/gas_mixture/environment = T.return_air()
		var/pressure = environment.return_pressure()
		var/total_moles = environment.total_moles()
		data["AirPressure"] = round(pressure,0.1)
		data["AirTemp"] = round(environment.return_temperature()-T0C)
		if (total_moles)
			for(var/id in environment.get_gases())
				var/gas_level = environment.get_moles(id)/total_moles
				if(gas_level > 0)
					airlist += list(list("name" = "[GLOB.gas_data.names[id]]", "percentage" = round(gas_level*100, 0.01)))
		data["AirData"] = airlist
	return data

/datum/computer_file/program/atmosscan/ui_act(action, list/params)
	if(..())
		return TRUE
