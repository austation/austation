/datum/symptom/proc/AU_Start(datum/disease/advance/A)
	if(neutered)
		return FALSE
	next_activation = world.time + rand(symptom_delay_min * 10, symptom_delay_max * 10) //so it doesn't instantly activate on infection
	return TRUE

/datum/symptom/proc/AU_Severity_Set(datum/disease/advance/A)
	severity = initial(severity)

/datum/symptom/proc/AU_Activate(datum/disease/advance/A)
	if(!A)
		return FALSE //prevents a niche runtime where a disease procs on the same tick it is cured
	if(neutered)
		return FALSE
	if(world.time < next_activation)
		return FALSE
	else
		next_activation = world.time + rand(symptom_delay_min * 10, symptom_delay_max * 10)
		return TRUE
