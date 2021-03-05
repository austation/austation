/datum/symptom/nano_boost
	desc = "The virus reacts to nanites in the host's bloodstream by enhancing their replication cycle."

/datum/symptom/nano_boost/Activate(datum/disease/advance/A)
	AU_Activate(A)
	return

/datum/symptom/nano_boost/AU_Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/carbon/M = A.affected_mob
	SEND_SIGNAL(M, COMSIG_NANITE_ADJUST_VOLUME, 0.5 * power)
	if(reverse_boost && SEND_SIGNAL(M, COMSIG_HAS_NANITES))
		if(prob(A.stage_prob))
			A.stage = min(A.stage + 1,A.max_stages)
