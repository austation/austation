//Not to be confused with /obj/item/reagent_containers/food/drinks/bottle

/obj/item/reagent_containers/glass/bottle
	name = "bottle"
	desc = "A small bottle."
	icon_state = "bottle"
	item_state = "atoxinbottle"
	possible_transfer_amounts = list(5,10,15,25,30)
	volume = 30
	fill_icon_thresholds = list(0, 10, 30, 50, 70)

/obj/item/reagent_containers/glass/bottle/Initialize(mapload)
	. = ..()
	if(!icon_state)
		icon_state = "bottle"
	update_icon()

/obj/item/reagent_containers/glass/bottle/epinephrine
	name = "epinephrine bottle"
<<<<<<< HEAD
=======
	label_name = "epinephrine"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle. Contains epinephrine - used to stabilize patients."
	list_reagents = list(/datum/reagent/medicine/epinephrine = 30)

/obj/item/reagent_containers/glass/bottle/tricordrazine
	name = "tricordrazine bottle"
<<<<<<< HEAD
=======
	label_name = "tricordrazine"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle of tricordrazine. Used to aid in patient recovery."
	list_reagents = list(/datum/reagent/medicine/tricordrazine = 30)

/obj/item/reagent_containers/glass/bottle/spaceacillin
	name = "spaceacillin bottle"
<<<<<<< HEAD
=======
	label_name = "spaceacillin"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle of spaceacillin. Used to cure some diseases."
	list_reagents = list(/datum/reagent/medicine/spaceacillin = 30)

/obj/item/reagent_containers/glass/bottle/antitoxin
	name = "antitoxin bottle"
<<<<<<< HEAD
	desc = "A small bottle of anti-toxin. Used to treat toxin damage."
	list_reagents = list(/datum/reagent/medicine/antitoxin = 30)

/obj/item/reagent_containers/glass/bottle/toxin
	name = "toxin bottle"
=======
	label_name = "antitoxin"
	desc = "A small bottle of anti-toxin. Used to treat toxin damage."
	list_reagents = list(/datum/reagent/medicine/antitoxin = 30)

/obj/item/reagent_containers/glass/bottle/toxin/mutagen
	name = "mutagen toxin bottle"
	label_name = "mutagen toxin"
	desc = "A small bottle of mutagen toxins. Do not drink, Might cause unpredictable mutations."
	list_reagents = list(/datum/reagent/toxin/mutagen = 30)

/obj/item/reagent_containers/glass/bottle/toxin
	name = "toxin bottle"
	label_name = "toxin"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle of toxins. Do not drink, it is poisonous."
	list_reagents = list(/datum/reagent/toxin = 30)

/obj/item/reagent_containers/glass/bottle/cyanide
	name = "cyanide bottle"
<<<<<<< HEAD
=======
	label_name = "cyanide"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle of cyanide. Bitter almonds?"
	list_reagents = list(/datum/reagent/toxin/cyanide = 30)

/obj/item/reagent_containers/glass/bottle/spewium
	name = "spewium bottle"
<<<<<<< HEAD
=======
	label_name = "spewium"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle of spewium."
	list_reagents = list(/datum/reagent/toxin/spewium = 30)

/obj/item/reagent_containers/glass/bottle/morphine
	name = "morphine bottle"
<<<<<<< HEAD
=======
	label_name = "morphine"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle of morphine."
	icon = 'icons/obj/chemical.dmi'
	list_reagents = list(/datum/reagent/medicine/morphine = 30)

/obj/item/reagent_containers/glass/bottle/chloralhydrate
	name = "chloral hydrate bottle"
<<<<<<< HEAD
=======
	label_name = "chloral hydrate"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle of Choral Hydrate. Mickey's Favorite!"
	icon_state = "bottle20"
	list_reagents = list(/datum/reagent/toxin/chloralhydrate = 30)

/obj/item/reagent_containers/glass/bottle/mannitol
	name = "mannitol bottle"
<<<<<<< HEAD
=======
	label_name = "mannitol"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle of Mannitol. Useful for healing brain damage."
	list_reagents = list(/datum/reagent/medicine/mannitol = 30)

/obj/item/reagent_containers/glass/bottle/charcoal
	name = "charcoal bottle"
<<<<<<< HEAD
=======
	label_name = "charcoal"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle of charcoal, which removes toxins and other chemicals from the bloodstream."
	list_reagents = list(/datum/reagent/medicine/charcoal = 30)

/obj/item/reagent_containers/glass/bottle/mutagen
	name = "unstable mutagen bottle"
<<<<<<< HEAD
=======
	label_name = "unstable mutagen"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle of unstable mutagen. Randomly changes the DNA structure of whoever comes in contact."
	list_reagents = list(/datum/reagent/toxin/mutagen = 30)

/obj/item/reagent_containers/glass/bottle/plasma
	name = "liquid plasma bottle"
<<<<<<< HEAD
=======
	label_name = "liquid plasma"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle of liquid plasma. Extremely toxic and reacts with micro-organisms inside blood."
	list_reagents = list(/datum/reagent/toxin/plasma = 30)

/obj/item/reagent_containers/glass/bottle/synaptizine
	name = "synaptizine bottle"
<<<<<<< HEAD
=======
	label_name = "synaptizine"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle of synaptizine."
	list_reagents = list(/datum/reagent/medicine/synaptizine = 30)

/obj/item/reagent_containers/glass/bottle/formaldehyde
	name = "formaldehyde bottle"
<<<<<<< HEAD
=======
	label_name = "formaldehyde"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle of formaldehyde."
	list_reagents = list(/datum/reagent/toxin/formaldehyde = 30)

/obj/item/reagent_containers/glass/bottle/cryostylane
	name = "cryostylane bottle"
<<<<<<< HEAD
=======
	label_name = "cryostylane"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle of cryostylane. It feels cold to the touch."
	list_reagents = list(/datum/reagent/cryostylane = 30)

/obj/item/reagent_containers/glass/bottle/ammonia
	name = "ammonia bottle"
<<<<<<< HEAD
=======
	label_name = "ammonia"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle of ammonia."
	list_reagents = list(/datum/reagent/ammonia = 30)

/obj/item/reagent_containers/glass/bottle/diethylamine
	name = "diethylamine bottle"
<<<<<<< HEAD
=======
	label_name = "diethylamine"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle of diethylamine."
	list_reagents = list(/datum/reagent/diethylamine = 30)

/obj/item/reagent_containers/glass/bottle/facid
<<<<<<< HEAD
	name = "Fluorosulfuric Acid Bottle"
=======
	name = "Fluorosulfuric Acid bottle"
	label_name = "Fluorosulfuric Acid"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle. Contains a small amount of fluorosulfuric acid."
	list_reagents = list(/datum/reagent/toxin/acid/fluacid = 30)

/obj/item/reagent_containers/glass/bottle/adminordrazine
<<<<<<< HEAD
	name = "Adminordrazine Bottle"
=======
	name = "Adminordrazine bottle"
	label_name = "Adminordrazine"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle. Contains the liquid essence of the gods."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "holyflask"
	list_reagents = list(/datum/reagent/medicine/adminordrazine = 30)

/obj/item/reagent_containers/glass/bottle/viralbase
<<<<<<< HEAD
	name = "Highly potent Viral Base Bottle"
=======
	name = "Highly potent Viral Base bottle"
	label_name = "Highly potent Viral Base"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle. Contains a trace amount of a substance found by scientists that can be used to create extremely advanced diseases once exposed to uranium."
	list_reagents = list(/datum/reagent/consumable/virus_food/viralbase = 1)

/obj/item/reagent_containers/glass/bottle/capsaicin
<<<<<<< HEAD
	name = "Capsaicin Bottle"
=======
	name = "Capsaicin bottle"
	label_name = "Capsaicin"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle. Contains hot sauce."
	list_reagents = list(/datum/reagent/consumable/capsaicin = 30)

/obj/item/reagent_containers/glass/bottle/frostoil
<<<<<<< HEAD
	name = "Frost Oil Bottle"
=======
	name = "Frost Oil bottle"
	label_name = "Frost Oil"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle. Contains cold sauce."
	list_reagents = list(/datum/reagent/consumable/frostoil = 30)

/obj/item/reagent_containers/glass/bottle/traitor
	name = "syndicate bottle"
<<<<<<< HEAD
=======
	label_name = "syndicate"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle. Contains a random nasty chemical."
	icon = 'icons/obj/chemical.dmi'
	var/extra_reagent = null

/obj/item/reagent_containers/glass/bottle/traitor/Initialize(mapload)
	. = ..()
	extra_reagent = pick(/datum/reagent/toxin/polonium, /datum/reagent/toxin/histamine, /datum/reagent/toxin/formaldehyde, /datum/reagent/toxin/venom, /datum/reagent/toxin/fentanyl, /datum/reagent/toxin/cyanide)
	reagents.add_reagent(extra_reagent, 3)

/obj/item/reagent_containers/glass/bottle/polonium
	name = "polonium bottle"
<<<<<<< HEAD
=======
	label_name = "polonium"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle. Contains Polonium."
	list_reagents = list(/datum/reagent/toxin/polonium = 30)

/obj/item/reagent_containers/glass/bottle/magillitis
	name = "magillitis bottle"
<<<<<<< HEAD
=======
	label_name = "magillitis"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle. Contains a serum known only as 'magillitis'."
	list_reagents = list(/datum/reagent/magillitis = 5)

/obj/item/reagent_containers/glass/bottle/venom
	name = "venom bottle"
<<<<<<< HEAD
=======
	label_name = "venom"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle. Contains Venom."
	list_reagents = list(/datum/reagent/toxin/venom = 30)

/obj/item/reagent_containers/glass/bottle/fentanyl
	name = "fentanyl bottle"
<<<<<<< HEAD
=======
	label_name = "fentanyl"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle. Contains Fentanyl."
	list_reagents = list(/datum/reagent/toxin/fentanyl = 30)

/obj/item/reagent_containers/glass/bottle/formaldehyde
	name = "formaldehyde bottle"
<<<<<<< HEAD
=======
	label_name = "formaldehyde"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle. Contains Formaldehyde."
	list_reagents = list(/datum/reagent/toxin/formaldehyde = 30)

/obj/item/reagent_containers/glass/bottle/initropidril
	name = "initropidril bottle"
<<<<<<< HEAD
=======
	label_name = "initropidril"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle. Contains initropidril."
	list_reagents = list(/datum/reagent/toxin/initropidril = 30)

/obj/item/reagent_containers/glass/bottle/pancuronium
	name = "pancuronium bottle"
<<<<<<< HEAD
=======
	label_name = "pancuronium"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle. Contains pancuronium."
	list_reagents = list(/datum/reagent/toxin/pancuronium = 30)

/obj/item/reagent_containers/glass/bottle/sodium_thiopental
	name = "sodium thiopental bottle"
<<<<<<< HEAD
=======
	label_name = "sodium thiopental"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle. Contains sodium thiopental."
	list_reagents = list(/datum/reagent/toxin/sodium_thiopental = 30)

/obj/item/reagent_containers/glass/bottle/coniine
	name = "coniine bottle"
<<<<<<< HEAD
=======
	label_name = "coniine"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle. Contains coniine."
	list_reagents = list(/datum/reagent/toxin/coniine = 30)

/obj/item/reagent_containers/glass/bottle/curare
	name = "curare bottle"
<<<<<<< HEAD
=======
	label_name = "curare"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle. Contains curare."
	list_reagents = list(/datum/reagent/toxin/curare = 30)

/obj/item/reagent_containers/glass/bottle/amanitin
	name = "amanitin bottle"
<<<<<<< HEAD
=======
	label_name = "amanitin"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle. Contains amanitin."
	list_reagents = list(/datum/reagent/toxin/amanitin = 30)

/obj/item/reagent_containers/glass/bottle/histamine
	name = "histamine bottle"
<<<<<<< HEAD
=======
	label_name = "histamine"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle. Contains Histamine."
	list_reagents = list(/datum/reagent/toxin/histamine = 30)

/obj/item/reagent_containers/glass/bottle/diphenhydramine
	name = "antihistamine bottle"
<<<<<<< HEAD
=======
	label_name = "antihistamine"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle of diphenhydramine."
	list_reagents = list(/datum/reagent/medicine/diphenhydramine = 30)

/obj/item/reagent_containers/glass/bottle/potass_iodide
	name = "anti-radiation bottle"
<<<<<<< HEAD
=======
	label_name = "anti-radiation"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle of potassium iodide."
	list_reagents = list(/datum/reagent/medicine/potass_iodide = 30)

/obj/item/reagent_containers/glass/bottle/salglu_solution
	name = "saline-glucose bottle"
<<<<<<< HEAD
=======
	label_name = "saline-glucose"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle of saline-glucose solution. Useful for patients lacking in blood volume."
	list_reagents = list(/datum/reagent/medicine/salglu_solution = 30)

/obj/item/reagent_containers/glass/bottle/atropine
	name = "atropine bottle"
<<<<<<< HEAD
=======
	label_name = "atropine"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle of atropine."
	list_reagents = list(/datum/reagent/medicine/atropine = 30)

/obj/item/reagent_containers/glass/bottle/romerol
	name = "romerol bottle"
<<<<<<< HEAD
	desc = "A small bottle of Romerol. The REAL zombie powder."
	list_reagents = list(/datum/reagent/romerol = 30)

/obj/item/reagent_containers/glass/bottle/random_virus
	name = "Experimental disease culture bottle"
=======
	label_name = "romerol"
	desc = "A small bottle of Romerol. The REAL zombie powder."
	list_reagents = list(/datum/reagent/romerol = 30)

/obj/item/reagent_containers/glass/bottle/random_virus/minor //for mail only...yet
	name = "Minor experimental disease culture bottle"
	label_name = "Minor experimental disease culture"
	desc = "A small bottle. Contains a weak version of an untested viral culture in synthblood medium."
	spawned_disease = /datum/disease/advance/random/minor

/obj/item/reagent_containers/glass/bottle/random_virus
	name = "Experimental disease culture bottle"
	label_name = "Experimental disease culture"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle. Contains an untested viral culture in synthblood medium."
	spawned_disease = /datum/disease/advance/random

/obj/item/reagent_containers/glass/bottle/pierrot_throat
	name = "Pierrot's Throat culture bottle"
<<<<<<< HEAD
=======
	label_name = "Pierrot's Throat culture"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle. Contains H0NI<42 virion culture in synthblood medium."
	spawned_disease = /datum/disease/pierrot_throat

/obj/item/reagent_containers/glass/bottle/cold
	name = "Rhinovirus culture bottle"
<<<<<<< HEAD
=======
	label_name = "Rhinovirus culture"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle. Contains XY-rhinovirus culture in synthblood medium."
	spawned_disease = /datum/disease/advance/cold

/obj/item/reagent_containers/glass/bottle/flu_virion
	name = "Flu virion culture bottle"
<<<<<<< HEAD
=======
	label_name = "Flu virion culture"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle. Contains H13N1 flu virion culture in synthblood medium."
	spawned_disease = /datum/disease/advance/flu

/obj/item/reagent_containers/glass/bottle/retrovirus
	name = "Retrovirus culture bottle"
<<<<<<< HEAD
=======
	label_name = "Retrovirus culture"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle. Contains a retrovirus culture in a synthblood medium."
	spawned_disease = /datum/disease/dna_retrovirus

/obj/item/reagent_containers/glass/bottle/gbs
	name = "GBS culture bottle"
<<<<<<< HEAD
=======
	label_name = "GBS culture"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle. Contains Gravitokinetic Bipotential SADS+ culture in synthblood medium."//Or simply - General BullShit
	amount_per_transfer_from_this = 5
	spawned_disease = /datum/disease/gbs

/obj/item/reagent_containers/glass/bottle/fake_gbs
	name = "GBS culture bottle"
<<<<<<< HEAD
=======
	label_name = "GBS culture"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle. Contains Gravitokinetic Bipotential SADS- culture in synthblood medium."//Or simply - General BullShit
	spawned_disease = /datum/disease/fake_gbs

/obj/item/reagent_containers/glass/bottle/brainrot
	name = "Brainrot culture bottle"
<<<<<<< HEAD
=======
	label_name = "Brainrot culture"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle. Contains Cryptococcus Cosmosis culture in synthblood medium."
	icon_state = "bottle3"
	spawned_disease = /datum/disease/brainrot

/obj/item/reagent_containers/glass/bottle/magnitis
	name = "Magnitis culture bottle"
<<<<<<< HEAD
=======
	label_name = "Magnitis culture"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle. Contains a small dosage of Fukkos Miracos."
	spawned_disease = /datum/disease/magnitis

/obj/item/reagent_containers/glass/bottle/wizarditis
	name = "Wizarditis culture bottle"
<<<<<<< HEAD
=======
	label_name = "Wizarditis culture"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle. Contains a sample of Rincewindus Vulgaris."
	spawned_disease = /datum/disease/wizarditis

/obj/item/reagent_containers/glass/bottle/anxiety
	name = "Severe Anxiety culture bottle"
<<<<<<< HEAD
=======
	label_name = "Severe Anxiety culture"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle. Contains a sample of Lepidopticides."
	spawned_disease = /datum/disease/anxiety

/obj/item/reagent_containers/glass/bottle/beesease
	name = "Beesease culture bottle"
<<<<<<< HEAD
=======
	label_name = "Beesease culture"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle. Contains a sample of invasive Apidae."
	spawned_disease = /datum/disease/beesease

/obj/item/reagent_containers/glass/bottle/fluspanish
	name = "Spanish flu culture bottle"
<<<<<<< HEAD
=======
	label_name = "Spanish flu culture"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle. Contains a sample of Inquisitius."
	spawned_disease = /datum/disease/fluspanish

/obj/item/reagent_containers/glass/bottle/tuberculosis
	name = "Fungal Tuberculosis culture bottle"
<<<<<<< HEAD
=======
	label_name = "Fungal Tuberculosis culture"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle. Contains a sample of Fungal Tubercle bacillus."
	spawned_disease = /datum/disease/tuberculosis

/obj/item/reagent_containers/glass/bottle/tuberculosiscure
	name = "BVAK bottle"
<<<<<<< HEAD
=======
	label_name = "BVAK"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle containing Bio Virus Antidote Kit."
	list_reagents = list(/datum/reagent/medicine/atropine = 5, /datum/reagent/medicine/epinephrine = 5, /datum/reagent/medicine/salbutamol = 10, /datum/reagent/medicine/spaceacillin = 10)

/obj/item/reagent_containers/glass/bottle/necropolis_seed
	name = "bowl of blood"
<<<<<<< HEAD
=======
	label_name = "blood"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A clay bowl containing a fledgling Necropolis, preserved in blood. A robust virologist may be able to unlock its full potential..."
	icon_state = "mortar"
	spawned_disease = /datum/disease/advance/random/necropolis

/obj/item/reagent_containers/glass/bottle/felinid
	name = "Nano-Feline Assimilative Toxoplasmosis culture bottle"
<<<<<<< HEAD
=======
	label_name = "Nano-Feline Assimilative Toxoplasmosis culture"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle. Contains a sample of nano-feline toxoplasma in synthblood medium."
	spawned_disease = /datum/disease/transformation/felinid/contagious

/obj/item/reagent_containers/glass/bottle/advanced_felinid
	name = "Feline Hysteria culture bottle"
<<<<<<< HEAD
=======
	label_name = "Feline Hysteria culture"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	desc = "A small bottle. Contains a sample of a dangerous A.R.C. experimental disease"
	spawned_disease = /datum/disease/advance/feline_hysteria

//Oldstation.dmm chemical storage bottles

/obj/item/reagent_containers/glass/bottle/hydrogen
	name = "hydrogen bottle"
<<<<<<< HEAD
=======
	label_name = "hydrogen"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	list_reagents = list(/datum/reagent/hydrogen = 30)

/obj/item/reagent_containers/glass/bottle/lithium
	name = "lithium bottle"
<<<<<<< HEAD
=======
	label_name = "lithium"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	list_reagents = list(/datum/reagent/lithium = 30)

/obj/item/reagent_containers/glass/bottle/carbon
	name = "carbon bottle"
<<<<<<< HEAD
=======
	label_name = "carbon"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	list_reagents = list(/datum/reagent/carbon = 30)

/obj/item/reagent_containers/glass/bottle/nitrogen
	name = "nitrogen bottle"
<<<<<<< HEAD
=======
	label_name = "nitrogen"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	list_reagents = list(/datum/reagent/nitrogen = 30)

/obj/item/reagent_containers/glass/bottle/oxygen
	name = "oxygen bottle"
<<<<<<< HEAD
=======
	label_name = "oxygen"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	list_reagents = list(/datum/reagent/oxygen = 30)

/obj/item/reagent_containers/glass/bottle/fluorine
	name = "fluorine bottle"
<<<<<<< HEAD
=======
	label_name = "fluorine"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	list_reagents = list(/datum/reagent/fluorine = 30)

/obj/item/reagent_containers/glass/bottle/sodium
	name = "sodium bottle"
<<<<<<< HEAD
=======
	label_name = "sodium"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	list_reagents = list(/datum/reagent/sodium = 30)

/obj/item/reagent_containers/glass/bottle/aluminium
	name = "aluminium bottle"
<<<<<<< HEAD
=======
	label_name = "aluminium"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	list_reagents = list(/datum/reagent/aluminium = 30)

/obj/item/reagent_containers/glass/bottle/silicon
	name = "silicon bottle"
<<<<<<< HEAD
=======
	label_name = "silicon"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	list_reagents = list(/datum/reagent/silicon = 30)

/obj/item/reagent_containers/glass/bottle/phosphorus
	name = "phosphorus bottle"
<<<<<<< HEAD
=======
	label_name = "phosphorus"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	list_reagents = list(/datum/reagent/phosphorus = 30)

/obj/item/reagent_containers/glass/bottle/sulfur
	name = "sulfur bottle"
<<<<<<< HEAD
=======
	label_name = "sulfur"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	list_reagents = list(/datum/reagent/sulfur = 30)

/obj/item/reagent_containers/glass/bottle/chlorine
	name = "chlorine bottle"
<<<<<<< HEAD
=======
	label_name = "chlorine"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	list_reagents = list(/datum/reagent/chlorine = 30)

/obj/item/reagent_containers/glass/bottle/potassium
	name = "potassium bottle"
<<<<<<< HEAD
=======
	label_name = "potassium"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	list_reagents = list(/datum/reagent/potassium = 30)

/obj/item/reagent_containers/glass/bottle/iron
	name = "iron bottle"
<<<<<<< HEAD
=======
	label_name = "iron"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	list_reagents = list(/datum/reagent/iron = 30)

/obj/item/reagent_containers/glass/bottle/copper
	name = "copper bottle"
<<<<<<< HEAD
=======
	label_name = "copper"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	list_reagents = list(/datum/reagent/copper = 30)

/obj/item/reagent_containers/glass/bottle/mercury
	name = "mercury bottle"
<<<<<<< HEAD
=======
	label_name = "mercury"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	list_reagents = list(/datum/reagent/mercury = 30)

/obj/item/reagent_containers/glass/bottle/radium
	name = "radium bottle"
<<<<<<< HEAD
=======
	label_name = "radium"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	list_reagents = list(/datum/reagent/uranium/radium = 30)

/obj/item/reagent_containers/glass/bottle/water
	name = "water bottle"
<<<<<<< HEAD
=======
	label_name = "water"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	list_reagents = list(/datum/reagent/water = 30)

/obj/item/reagent_containers/glass/bottle/ethanol
	name = "ethanol bottle"
<<<<<<< HEAD
=======
	label_name = "ethanol"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	list_reagents = list(/datum/reagent/consumable/ethanol = 30)

/obj/item/reagent_containers/glass/bottle/sugar
	name = "sugar bottle"
<<<<<<< HEAD
=======
	label_name = "sugar"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	list_reagents = list(/datum/reagent/consumable/sugar = 30)

/obj/item/reagent_containers/glass/bottle/sacid
	name = "sulphuric acid bottle"
<<<<<<< HEAD
=======
	label_name = "sulphuric acid"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	list_reagents = list(/datum/reagent/toxin/acid = 30)

/obj/item/reagent_containers/glass/bottle/welding_fuel
	name = "welding fuel bottle"
<<<<<<< HEAD
=======
	label_name = "welding fuel"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	list_reagents = list(/datum/reagent/fuel = 30)

/obj/item/reagent_containers/glass/bottle/silver
	name = "silver bottle"
<<<<<<< HEAD
=======
	label_name = "silver"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	list_reagents = list(/datum/reagent/silver = 30)

/obj/item/reagent_containers/glass/bottle/iodine
	name = "iodine bottle"
<<<<<<< HEAD
=======
	label_name = "iodine"
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
	list_reagents = list(/datum/reagent/iodine = 30)

/obj/item/reagent_containers/glass/bottle/bromine
	name = "bromine bottle"
<<<<<<< HEAD
	list_reagents = list(/datum/reagent/bromine = 30)
=======
	label_name = "bromine"
	list_reagents = list(/datum/reagent/bromine = 30)

// Bottles for mail goodies.

/obj/item/reagent_containers/glass/bottle/clownstears
	name = "bottle of distilled clown misery"
	label_name = "distilled clown misery"
	desc = "A small bottle. Contains a mythical liquid used by sublime bartenders; made from the unhappiness of clowns."
	list_reagents = list(/datum/reagent/consumable/clownstears = 30)

/obj/item/reagent_containers/glass/bottle/saltpetre
	name = "saltpetre bottle"
	label_name = "saltpetre"
	desc = "A small bottle. Contains saltpetre."
	list_reagents = list(/datum/reagent/saltpetre = 30)

/obj/item/reagent_containers/glass/bottle/flash_powder
	name = "flash powder bottle"
	label_name = "flash powder"
	desc = "A small bottle. Contains flash powder."
	list_reagents = list(/datum/reagent/flash_powder = 30)

/obj/item/reagent_containers/glass/bottle/caramel
	name = "bottle of caramel"
	label_name = "caramel"
	desc = "A bottle containing caramalized sugar, also known as caramel. Do not lick."
	list_reagents = list(/datum/reagent/consumable/caramel = 30)

/obj/item/reagent_containers/glass/bottle/ketamine
	name = "ketamine bottle"
	label_name = "ketamine"
	desc = "A small bottle. Contains ketamine, why?"
	list_reagents = list(/datum/reagent/drug/ketamine = 30)
>>>>>>> 4cce6a1647 (fixes bottles don't display its name on vending machine (#8059))
