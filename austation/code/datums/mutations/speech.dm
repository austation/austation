/datum/mutation/human/nya
	name = "Nya"
	desc = "A deadly genetic disorder, which severely impeeds the speech center's capacity for self control."
	quality = MINOR_NEGATIVE

	text_gain_indication = "<span class='warning'>Nya?</span>"
	text_lose_indication = "<span class='notice'>Thank the stars, your speech feels normal again!</span>"
	locked = TRUE

/datum/generecipe/nya
	required = "/datum/mutation/human/smile; /datum/mutation/human/clumsy"
	result = /datum/mutation/human/nya

/datum/mutation/human/nya/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	RegisterSignal(owner, COMSIG_MOB_SAY, .proc/handle_speech)

/datum/mutation/human/nya/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	UnregisterSignal(owner, COMSIG_MOB_SAY)

/datum/mutation/human/nya/proc/handle_speech(datum/source, list/speech_args)
	var/message = speech_args[SPEECH_MESSAGE]
	if(message)
		message = " [message] "

		// Cheers to "@Edgar Allan Shitpoest#6969" for this source:
		// https://whiskerstotailspetsitting.com/2017/05/purr-fect-list-cat-vocabulary-not-kitten-around/
		// Now the cursed factor of our mutation is out of this world

		// Specic word replacements
		message = replacetext(message," kidding "," kitten ")
		message = replacetext(message," awful "," clawful ")
		message = replacetext(message," athletic "," cathletic ")
		message = replacetext(message," feeling "," feline ")
		message = replacetext(message," clever "," clawver ")
		message = replacetext(message," tale "," tail ")
		message = replacetext(message," pretty "," purrty ")
		message = replacetext(message," familiar "," furmiliar ")
		message = replacetext(message," now "," meow ")
		message = replacetext(message," radical "," radiclaw ")
		message = replacetext(message," music "," mewsic ")
		message = replacetext(message," you "," mew ")
		message = replacetext(message," minimum "," mewnimum ")
		message = replacetext(message," himself "," hisself ")
		message = replacetext(message," misery "," mewsery ")
		message = replacetext(message," very "," furry ")
		message = replacetext(message," bruh"," nya")

		// Sylabel replacement
		message = replacetext(message,"no","nya")
		message = replacetext(message," pur"," purr")
		message = replacetext(message," per"," purr") // Note the spaces preventing it from being in the middle of a word
		message = replacetext(message," pos"," paws")
		message = replacetext(message," par"," paw") // why are these all similar?
		message = replacetext(message,"for","fur")
		message = replacetext(message,"fer","fur")
		message = replacetext(message," a"," nya")

		// It wasn't cursed enough? I gotcha covered.

		switch(rand(1,8))
			if (1)
				message = "[message]"
			if (2)
				message = "[message] [get_nya()]"
			if (3)
				message = "[message] [get_nya()]"
			if (4)
				message = "[message] [get_nya()] [get_nya()]"
			if (5)
				message = "[get_nya()] [message]"
			if (6) // 3/8 chance to deny your shouts of ling in maint
				message = "[get_nya()]"
			if (7)
				message = "[get_nya()] [get_nya()] [get_nya()]"
			if (8)
				message = "[get_nya()] [get_nya()] [get_nya()] [get_nya()] [get_nya()]"

		speech_args[SPEECH_MESSAGE] = trim(message)

/datum/mutation/human/nya/proc/get_nya() // Nya
	return pick("Nya.", "Nya ~", "Nya!", "Nya...", "Nya!!", "Nyaaaa", "Nya")
