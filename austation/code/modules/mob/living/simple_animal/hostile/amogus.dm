var/static/list/amo_colours = list(
	"red",
	"blue",
	"green",
	"yellow",
	"cyan",
	"purple",
	"brown"
	)
var/list/available_colours = amo_colours  //  Prevents the same colour being taken more than once, unless we have more than 7 amogi.
var/datum/team/imposters/sus  //  The imposters team. There is only one.

/datum/team/imposters
	name = "imposter squad"
	var/datum/objective/mission  //  Taken from the admin when they create the team with create_antagonist

/datum/antagonist/imposter
	name = "Imposter"
	var/datum/team/imposters/imposter_team
	var/leader = FALSE
	show_to_ghosts = FALSE
	var/datum/action/innate/change_colour/change_colour

/datum/action/innate/change_colour  //  Allows the imposter to take on the colours of the crewmembers. Yes I know they can't really do that in Among Us.
	name = "Swap disguise"
	icon_icon = 'austation/icons/mob/amogus.dmi'
	button_icon_state = "change_button"

/datum/action/innate/change_colour/Activate()
	var/new_colour = input("Choose new disguise:", "New colour") as null|anything in amo_colours  //  Willing to learn a better method. I grabbed this code from the genetics minigame.
	if(!new_colour)
		to_chat(owner, "<span class='warning'>No new colour selected.</span>")
		return
	if(!do_mob(owner, owner, 50))  //  If you want to change colour, you need to hold still for 5 seconds.
		return
	owner.icon_state = new_colour

/datum/antagonist/imposter/proc/create_actions()
	change_colour.Grant(owner)

/datum/antagonist/imposter/on_gain()
	forge_objectives()
	create_actions()
	owner.current.ventcrawler = VENTCRAWLER_ALWAYS  //  Imposters can vent crawl.  At least this much is a real ability they had.
	. = ..()

//  Pretty much line-for-line identical to antagonist/ert  vvv

/datum/antagonist/imposter/get_team()
	return imposter_team

/datum/antagonist/imposter/create_team(datum/team/imposters/new_team)
	if(istype(new_team))
		imposter_team = new_team

/datum/antagonist/imposter/proc/forge_objectives()
	if(imposter_team)
		objectives |= imposter_team.objectives

//  Pretty much line-for-line identical to antagonist/ert  ^^^

/datum/antagonist/imposter/greet()
	if(!imposter_team)
		return

	to_chat(owner, "<B><font size=3 color=red>You are the [name].</font></B>")

	var/missiondesc = "You are the imposter among us.\
	Do not get caught, eliminate all witnisses.\
	The crewmembers must not discover your true identity."

	missiondesc += "<BR><B>Your Mission</B> : [imposter_team.mission.explanation_text]"

/mob/living/simple_animal/hostile/stickman/amogus
	name = "Crewmate from Hit Videogame \"Among Us\""
	desc = "Red Sus!"
	icon = 'austation/icons/mob/amogus.dmi'
	icon_state = "red"
	deathsound = 'austation/sound/creatures/amongus_kill.ogg'
	turns_per_move = 1
	response_help = "hugs"
	response_disarm = "suspects"
	response_harm = "repots"
	maxHealth = 1000
	health = 1000
	melee_damage = 15
	attacktext = "ejects"
	check_friendly_fire = 0
	del_on_death = TRUE
	var/is_sus = FALSE

/mob/living/simple_animal/hostile/stickman/amogus/sus  //  Spawn one of these to force it to become an imposter.
	is_sus = TRUE

/mob/living/simple_animal/hostile/stickman/amogus/Initialize(mapload, wizard_summoned)
	. = ..()
	var/mob/M = src
	if(!length(available_colours))  //  We ran out of colours boss, what do we do; start a new set? I'd rather not just prevent the mob from being spawned.
		available_colours = amo_colours
	icon_state = pick(available_colours)
	available_colours &= ~icon_state

	if(!is_sus && sus && prob(70))  //  Don't create a new antag if all three are true:
									     //  1) Admin has not forced a new imposter
									     //  2) There is an existing imposter
									     //  3) The 70% chance fails
									     //  If any of these are false, create the new antag
		to_chat(src, "<span class=danger'>There is an imposter among us!\
		The imposter has many tricks up its sleeve, so be on your toes and ALWAYS report dead bodies!</span>")
		return
	if(!sus)  //  Need a new team
		sus = new /datum/team/imposters
	M.mind.add_antag_datum(/datum/antagonist/amogus, sus)
