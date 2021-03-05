/datum/symptom/viralreverse/Heal(mob/living/M, datum/disease/advance/A)
	A.stage -= 1
	if(A.stage < 2)
		to_chat(M, "<span class='notice'>You suddenly feel healthy.</span>")
		A.cure(FALSE)
