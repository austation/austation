/datum/voicebox
  var/list/welcome_list
  var/list/weapondestroy_list
  var/list/itemdestroy_list
  var/list/critical_list
  var/list/optical_list

/datum/voicebox/proc/welcome()
  return pick(welcome_list)

/datum/voicebox/proc/weapondest()
  return pick(weapondestroy_list)

/datum/voicebox/proc/itemdest()
  return pick(itemdestroy_list)

/datum/voicebox/proc/critical()
  return pick(critical_list)

/datum/voicebox/proc/optical()
  return pick(optical_list)

/datum/voicebox/working
	welcome_list = list(
		'austation/sound/mecha/working/welcome_a.ogg',
		'austation/sound/mecha/working/welcome_b.ogg')
	itemdestroy_list = list(
		'austation/sound/mecha/working/itemdestroy_a.ogg',
		'austation/sound/mecha/working/itemdestroy_b.ogg')
	weapondestroy_list = list(
		'austation/sound/mecha/working/weapondestroy_a.ogg',
		'austation/sound/mecha/working/weapondestroy_b.ogg')
	critical_list = list(
		'austation/sound/mecha/working/critical_a.ogg',
		'austation/sound/mecha/working/critical_b.ogg')
	optical_list = list(
		'austation/sound/mecha/working/optical_a.ogg',
		'austation/sound/mecha/working/optical_b.ogg')

/datum/voicebox/medical
	welcome_list = list(
		'austation/sound/mecha/medical/welcome_a.ogg',
		'austation/sound/mecha/medical/welcome_b.ogg')
	itemdestroy_list = list(
		'austation/sound/mecha/medical/itemdestroy_a.ogg',
		'austation/sound/mecha/medical/itemdestroy_b.ogg')
	weapondestroy_list = list(
		'austation/sound/mecha/medical/weapondestroy_a.ogg',
		'austation/sound/mecha/medical/weapondestroy_b.ogg')
	critical_list = list(
		'austation/sound/mecha/medical/critical_a.ogg',
		'austation/sound/mecha/medical/critical_b.ogg')
	optical_list = list(
		'austation/sound/mecha/medical/optical_a.ogg',
		'austation/sound/mecha/medical/optical_b.ogg')

/datum/voicebox/honk
	welcome_list = list(
		'austation/sound/mecha/honk/welcome_a.ogg',
		'austation/sound/mecha/honk/welcome_b.ogg')
	itemdestroy_list = list(
		'austation/sound/mecha/honk/itemdestroy_a.ogg',
		'austation/sound/mecha/honk/itemdestroy_b.ogg')
	weapondestroy_list = list(
		'austation/sound/mecha/honk/weapondestroy_a.ogg',
		'austation/sound/mecha/honk/weapondestroy_b.ogg')
	critical_list = list(
		'austation/sound/mecha/honk/critical_a.ogg',
		'austation/sound/mecha/honk/critical_b.ogg')
	optical_list = list(
		'austation/sound/mecha/honk/optical_a.ogg',
		'austation/sound/mecha/honk/optical_b.ogg')

/datum/voicebox/combat
	welcome_list = list(
		'austation/sound/mecha/combat/welcome_a.ogg',
		'austation/sound/mecha/combat/welcome_b.ogg')
	itemdestroy_list = list(
		'austation/sound/mecha/combat/itemdestroy_a.ogg',
		'austation/sound/mecha/combat/itemdestroy_b.ogg')
	weapondestroy_list = list(
		'austation/sound/mecha/combat/weapondestroy_a.ogg',
		'austation/sound/mecha/combat/weapondestroy_b.ogg')
	critical_list = list(
		'austation/sound/mecha/combat/critical_a.ogg',
		'austation/sound/mecha/combat/critical_b.ogg')
	optical_list = list(
		'austation/sound/mecha/combat/optical_a.ogg',
		'austation/sound/mecha/combat/optical_b.ogg')

/datum/voicebox/syndie
	welcome_list = list(
		'austation/sound/mecha/syndie/welcome_a.ogg',
		'austation/sound/mecha/syndie/welcome_b.ogg')
	itemdestroy_list = list(
		'austation/sound/mecha/syndie/itemdestroy_a.ogg',
		'austation/sound/mecha/syndie/itemdestroy_b.ogg')
	weapondestroy_list = list(
		'austation/sound/mecha/syndie/weapondestroy_a.ogg',
		'austation/sound/mecha/syndie/weapondestroy_b.ogg')
	critical_list = list(
		'austation/sound/mecha/syndie/critical_a.ogg',
		'austation/sound/mecha/syndie/critical_b.ogg')
	optical_list = list(
		'austation/sound/mecha/syndie/optical_a.ogg',
		'austation/sound/mecha/syndie/optical_b.ogg')

/datum/voicebox/reticense
	welcome_list = list('austation/sound/mecha/silent.ogg')
	itemdestroy_list = list('austation/sound/mecha/silent.ogg')
	weapondestroy_list = list('austation/sound/mecha/silent.ogg')
	critical_list = list('austation/sound/mecha/silent.ogg')
	optical_list = list('austation/sound/mecha/silent.ogg')

/obj/mecha
	var/datum/voicebox/voice

/obj/mecha/working
	voice = /datum/voicebox/working

/obj/mecha/medical
	voice = /datum/voicebox/medical

/obj/mecha/combat/Initialize()
	. = ..()
	if(istype(src, /obj/mecha/combat/marauder) && !istype(src, /obj/mecha/combat/marauder/seraph))
		voice = /datum/voicebox/syndie
		return
	if(istype(src, /obj/mecha/combat/reticence))
		voice = /datum/voicebox/reticense
		return
	if(!istype(src, /obj/mecha/combat/honker))
		voice = /datum/voicebox/honk
		return
	voice = /datum/voicebox/combat
