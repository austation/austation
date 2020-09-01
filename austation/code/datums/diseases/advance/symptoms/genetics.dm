/datum/symptom/genetic_mutation
  stealth = -1
  resistance = -2
  transmittable = -2
  no_reset = TRUE
  threshold_desc = "<b>Resistance 8:</b> Causes two mutations at once.<br>\
                  <b>Stage Speed 10:</b> Increases mutation frequency.<br>\
                  <b>Stage Speed 14:</b> Mutations will be beneficial."

/datum/symptom/genetic_mutation/severityset(datum/disease/advance/A)
  AU_Severity_Set(A)

/datum/symptom/genetic_mutation/AU_Severity_Set(datum/disease/advance/A)
	. = ..()
	if(A.properties["stage_rate"] >= 14)
		severity = -1
	else if(A.properties["resistance"] >= 8)
		severity += 1

/datum/symptom/genetic_mutation/Start(datum/disease/advance/A)
  ..()

  if(A.properties["stage_rate"] >= 14)
    possible_mutations = GLOB.good_mutations - GLOB.all_mutations[RACEMUT]
