
//Preference toggles
#define SOUND_ADMINHELP			(1<<0)
#define SOUND_MIDI				(1<<1)
#define SOUND_AMBIENCE			(1<<2)
#define SOUND_LOBBY				(1<<3)
#define MEMBER_PUBLIC			(1<<4)
#define INTENT_STYLE			(1<<5)
#define MIDROUND_ANTAG			(1<<6)
#define SOUND_INSTRUMENTS		(1<<7)
#define SOUND_SHIP_AMBIENCE		(1<<8)
#define SOUND_PRAYERS			(1<<9)
#define ANNOUNCE_LOGIN			(1<<10)
#define SOUND_ANNOUNCEMENTS		(1<<11)
#define DISABLE_DEATHRATTLE		(1<<12)
#define DISABLE_ARRIVALRATTLE	(1<<13)
#define COMBOHUD_LIGHTING		(1<<14)

#define DEADMIN_ALWAYS			(1<<15)
#define DEADMIN_ANTAGONIST		(1<<16)
#define DEADMIN_POSITION_HEAD	(1<<17)
#define DEADMIN_POSITION_SECURITY	(1<<18)
#define DEADMIN_POSITION_SILICON	(1<<19)

<<<<<<< HEAD
#define TOGGLES_DEFAULT (SOUND_ADMINHELP|SOUND_MIDI|SOUND_AMBIENCE|SOUND_LOBBY|MEMBER_PUBLIC|INTENT_STYLE|MIDROUND_ANTAG|SOUND_INSTRUMENTS|SOUND_SHIP_AMBIENCE|SOUND_PRAYERS|SOUND_ANNOUNCEMENTS)
=======
#define PREFTOGGLE_OUTLINE_ENABLED				(1<<20)
#define PREFTOGGLE_RUNECHAT_GLOBAL				(1<<21)
#define PREFTOGGLE_RUNECHAT_NONMOBS				(1<<22)
#define PREFTOGGLE_RUNECHAT_EMOTES				(1<<23)

#define TOGGLES_DEFAULT (PREFTOGGLE_SOUND_ADMINHELP|PREFTOGGLE_SOUND_MIDI|PREFTOGGLE_SOUND_AMBIENCE|PREFTOGGLE_SOUND_LOBBY|PREFTOGGLE_MEMBER_PUBLIC|PREFTOGGLE_INTENT_STYLE|PREFTOGGLE_MIDROUND_ANTAG|PREFTOGGLE_SOUND_INSTRUMENTS|PREFTOGGLE_SOUND_SHIP_AMBIENCE|PREFTOGGLE_SOUND_PRAYERS|PREFTOGGLE_SOUND_ANNOUNCEMENTS|PREFTOGGLE_OUTLINE_ENABLED|PREFTOGGLE_RUNECHAT_GLOBAL|PREFTOGGLE_RUNECHAT_NONMOBS|PREFTOGGLE_RUNECHAT_EMOTES)

// You CANNOT go above 1<<23 in BYOND due to integer limits
// Please add subsequent ones as PREFTOGGLE_2_[name]
// If you run out of these, make a third toggles column
#define PREFTOGGLE_2_FANCY_TGUI					(1<<0)
#define PREFTOGGLE_2_LOCKED_TGUI				(1<<1)
#define PREFTOGGLE_2_LOCKED_BUTTONS				(1<<2)
#define PREFTOGGLE_2_WINDOW_FLASHING			(1<<3)
#define PREFTOGGLE_2_CREW_OBJECTIVES			(1<<4)
#define PREFTOGGLE_2_GHOST_HUD					(1<<5)
#define PREFTOGGLE_2_GHOST_INQUISITIVENESS		(1<<6)
#define PREFTOGGLE_2_USES_GLASSES_COLOUR		(1<<7)
#define PREFTOGGLE_2_AMBIENT_OCCLUSION			(1<<8)
#define PREFTOGGLE_2_AUTO_FIT_VIEWPORT			(1<<9)
#define PREFTOGGLE_2_ENABLE_TIPS				(1<<10)
#define PREFTOGGLE_2_SHOW_CREDITS				(1<<11)
#define PREFTOGGLE_2_HOTKEYS					(1<<12)
#define PREFTOGGLE_2_SOUNDTRACK					(1<<13)
#define PREFTOGGLE_2_TGUI_INPUT					(1<<14)
#define PREFTOGGLE_2_BIG_BUTTONS				(1<<15)
#define PREFTOGGLE_2_SWITCHED_BUTTONS			(1<<16)
#define PREFTOGGLE_2_TGUI_SAY					(1<<17)
#define PREFTOGGLE_2_SAY_LIGHT_THEME			(1<<18)
#define PREFTOGGLE_2_SAY_SHOW_PREFIX			(1<<19)

#define TOGGLES_2_DEFAULT (PREFTOGGLE_2_FANCY_TGUI|PREFTOGGLE_2_LOCKED_TGUI|PREFTOGGLE_2_LOCKED_BUTTONS|PREFTOGGLE_2_WINDOW_FLASHING|PREFTOGGLE_2_CREW_OBJECTIVES|PREFTOGGLE_2_GHOST_HUD|PREFTOGGLE_2_GHOST_INQUISITIVENESS|PREFTOGGLE_2_AMBIENT_OCCLUSION|PREFTOGGLE_2_AUTO_FIT_VIEWPORT|PREFTOGGLE_2_ENABLE_TIPS|PREFTOGGLE_2_SHOW_CREDITS|PREFTOGGLE_2_HOTKEYS|PREFTOGGLE_2_SOUNDTRACK|PREFTOGGLE_2_TGUI_INPUT|PREFTOGGLE_2_BIG_BUTTONS|PREFTOGGLE_2_SWITCHED_BUTTONS|PREFTOGGLE_2_TGUI_SAY)
>>>>>>> cc88822153 (TGUI Say (#8404))

//Chat toggles
#define CHAT_OOC			(1<<0)
#define CHAT_DEAD			(1<<1)
#define CHAT_GHOSTEARS		(1<<2)
#define CHAT_GHOSTSIGHT		(1<<3)
#define CHAT_PRAYER			(1<<4)
#define CHAT_RADIO			(1<<5)
#define CHAT_PULLR			(1<<6)
#define CHAT_GHOSTWHISPER	(1<<7)
#define CHAT_GHOSTPDA		(1<<8)
#define CHAT_GHOSTRADIO 	(1<<9)
#define CHAT_BANKCARD  (1<<10)
#define CHAT_GHOSTLAWS	(1<<11)

#define TOGGLES_DEFAULT_CHAT (CHAT_OOC|CHAT_DEAD|CHAT_GHOSTEARS|CHAT_GHOSTSIGHT|CHAT_PRAYER|CHAT_RADIO|CHAT_PULLR|CHAT_GHOSTWHISPER|CHAT_GHOSTPDA|CHAT_GHOSTRADIO|CHAT_BANKCARD|CHAT_GHOSTLAWS)

#define PARALLAX_INSANE -1 //for show offs
#define PARALLAX_HIGH    0 //default.
#define PARALLAX_MED     1
#define PARALLAX_LOW     2
#define PARALLAX_DISABLE 3 //this option must be the highest number

#define PIXEL_SCALING_AUTO 0
#define PIXEL_SCALING_1X 1
#define PIXEL_SCALING_1_2X 1.5
#define PIXEL_SCALING_2X 2
#define PIXEL_SCALING_3X 3
#define PIXEL_SCALING_4X 4

#define SCALING_METHOD_NORMAL "normal"
#define SCALING_METHOD_DISTORT "distort"
#define SCALING_METHOD_BLUR "blur"

#define PARALLAX_DELAY_DEFAULT world.tick_lag
#define PARALLAX_DELAY_MED     1
#define PARALLAX_DELAY_LOW     2

#define SEC_DEPT_NONE "None"
#define SEC_DEPT_RANDOM "Random"
#define SEC_DEPT_ENGINEERING "Engineering"
#define SEC_DEPT_MEDICAL "Medical"
#define SEC_DEPT_SCIENCE "Science"
#define SEC_DEPT_SUPPLY "Supply"

// Playtime tracking system, see jobs_exp.dm
#define EXP_TYPE_LIVING			"Living"
#define EXP_TYPE_CREW			"Crew"
#define EXP_TYPE_COMMAND		"Command"
#define EXP_TYPE_ENGINEERING	"Engineering"
#define EXP_TYPE_MEDICAL		"Medical"
#define EXP_TYPE_SCIENCE		"Science"
#define EXP_TYPE_SUPPLY			"Supply"
#define EXP_TYPE_SECURITY		"Security"
#define EXP_TYPE_SILICON		"Silicon"
#define EXP_TYPE_SERVICE		"Service"
#define EXP_TYPE_GIMMICK		"Gimmick"
#define EXP_TYPE_ANTAG			"Antag"
#define EXP_TYPE_SPECIAL		"Special"
#define EXP_TYPE_GHOST			"Ghost"
#define EXP_TYPE_ADMIN			"Admin"

//Flags in the players table in the db
#define DB_FLAG_EXEMPT 1

#define DEFAULT_CYBORG_NAME "Default Cyborg Name"


//Job preferences levels
#define JP_LOW 1
#define JP_MEDIUM 2
#define JP_HIGH 3

//Backpacks
#define GBACKPACK "Grey Backpack"
#define GSATCHEL "Grey Satchel"
#define GDUFFELBAG "Grey Duffel Bag"
#define LSATCHEL "Leather Satchel"
#define DBACKPACK "Department Backpack"
#define DSATCHEL "Department Satchel"
#define DDUFFELBAG "Department Duffel Bag"

//Suit/Skirt
#define PREF_SUIT "Jumpsuit"
#define PREF_SKIRT "Jumpskirt"

//Uplink spawn loc
#define UPLINK_PDA "PDA"
#define UPLINK_RADIO "Radio"
#define UPLINK_PEN "Pen" //like a real spy!
#define UPLINK_IMPLANT "Implant"
#define UPLINK_IMPLANT_WITH_PRICE "[UPLINK_IMPLANT] (-[UPLINK_IMPLANT_TELECRYSTAL_COST] TC)"

//Plasmamen helmet styles, when you edit those remember to edit list in preferences.dm
#define HELMET_DEFAULT "Default"
#define HELMET_MK2 "Mark II"
#define HELMET_PROTECTIVE "Protective"
