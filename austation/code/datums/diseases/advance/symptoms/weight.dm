/datum/symptom/weight_loss
    name = "Weight Loss"
    desc = "The virus mutates the host's metabolism, making it almost unable to gain nutrition from food."
    stealth = -2
    resistance = 2
    stage_speed = -2
    transmission = -1
    level = 3
    severity = 2
    base_message_chance = 100
    symptom_delay_min = 15
    symptom_delay_max = 30
    threshold_desc = "<b>Resistance 8:</b> The symptom stops you from becoming fat.<br>\
                <b>Stealth 2:</b> The symptom is less noticeable."
    var/no_fat = FALSE

/datum/symptom/weight_loss/severityset(datum/disease/advance/A)
	AU_Severity_Set(A)

/datum/symptom/weight_loss/AU_Severity_Set(datum/disease/advance/A)
	. = ..()
	if(A.resistance >= 8)
		severity -= 3
		symptom_delay_min = 1
		symptom_delay_max = 1

/datum/symptom/weight_loss/Start(datum/disease/advance/A)
    AU_Start(A)

/datum/symptom/weight_loss/AU_Start(datum/disease/advance/A)
    if(!..())
        return
    if(A.resistance >= 8)
        no_fat = TRUE
    if(A.stealth >= 2)
        base_message_chance = 25

/datum/symptom/weight_loss/Activate(datum/disease/advance/A)
    AU_Activate(A)

/datum/symptom/weight_loss/AU_Activate(datum/disease/advance/A)
    if(!..())
        return
    var/mob/living/M = A.affected_mob
    switch(A.stage)
        if(1, 2, 3, 4)
            if(prob(base_message_chance) && !no_fat)
                to_chat(M, "<span class='warning'>[pick("You feel hungry.", "You crave for food.")]</span>")
        else
            if(!no_fat)
                to_chat(M, "<span class='warning'><i>[pick("So hungry...", "You'd kill someone for a bite of food...", "Hunger cramps seize you...")]</i></span>")
                M.overeatduration = max(M.overeatduration - 100, 0)
                M.adjust_nutrition(-100)
            else if(M.nutrition >= 525)
                M.adjust_nutrition(min(0, 525 - M.nutrition))
                M.overeatduration = 0
