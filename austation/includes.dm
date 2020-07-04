// AuStation includes file. Add all modularized code files here.

#include "code\controllers\configuration\entries\game_options.dm"
#include "code\controllers\configuration\entries\general.dm"
#include "code\controllers\subsystem\autosandbox.dm"
#include "code\controllers\subsystem\job.dm"
#include "code\datums\ai_laws.dm"
#include "code\datums\emotes.dm"
#include "code\datums\brain_damage\imaginary_friend.dm"
#include "code\datums\status_effects\buffs.dm"
#include "code\game\machinery\syndicatebeacon.dm"
#include "code\game\objects\effects\decals\turfdecal\markings.dm"
#include "code\game\objects\items\AI_modules.dm"
#include "code\game\objects\items\robot\robot_upgrades.dm"
#include "code\game\objects\items\storage\belt.dm"
#include "code\game\objects\items\storage\firstaid.dm"
#include "code\game\objects\items\storage\uplink_kits.dm"
#include "code\game\objects\items\twohanded.dm"
#include "code\game\objects\items\weaponry.dm"
#include "code\game\objects\structures\mirror.dm"
#include "code\game\turfs\open\lava.dm"
#include "code\modules\admin\chat_commands.dm"
#include "code\modules\admin\topic.dm"
#include "code\modules\admin\verbs\fix_air.dm"
#include "code\modules\admin\verbs\mapping.dm"
#include "code\modules\clothing\glasses\hud.dm"
#include "code\modules\clothing\spacesuit\miscellaneous.dm"
#include "code\modules\clothing\under\color.dm"
#include "code\modules\clothing\under\miscellaneous.dm"
#include "code\modules\clothing\under\jobs\engineering.dm"
#include "code\modules\clothing\under\jobs\medisci.dm"
#include "code\modules\clothing\under\jobs\security.dm"
#include "code\modules\clothing\under\jobs\civilian\civilian.dm"
#include "code\modules\events\bruh_moment.dm"
#include "code\modules\food_and_drinks\drinks\drinks.dm"
#include "code\modules\jobs\job_types\assistant.dm"
#include "code\modules\jobs\job_types\chief_medical_officer.dm"
#include "code\modules\jobs\job_types\emt.dm"
#include "code\modules\jobs\job_types\job.dm"
#include "code\modules\jobs\job_types\medical_doctor.dm"
#include "code\modules\language\buzzwords.dm"
#include "code\modules\language\calcic.dm"
#include "code\modules\language\language_holder.dm"
#include "code\modules\language\moffic.dm"
#include "code\modules\language\shadowtongue.dm"
#include "code\modules\language\sylvan.dm"
#include "code\modules\language\terrum.dm"
#include "code\modules\language\voltaic.dm"
#include "code\modules\mapping\writer.dm"
#include "code\modules\mob\mob_defines.dm"
#include "code\modules\mob\dead\new_player\new_player.dm"
#include "code\modules\mob\living\emote.dm"
#include "code\modules\mob\living\carbon\emote.dm"
#include "code\modules\mob\living\carbon\human\emote.dm"
#include "code\modules\mob\living\carbon\human\human_defines.dm"
#include "code\modules\mob\living\carbon\human\species.dm"
#include "code\modules\mob\living\carbon\human\species_type\ethereal.dm"
#include "code\modules\mob\living\carbon\human\species_type\felinid.dm"
#include "code\modules\mob\living\carbon\human\species_type\flypeople.dm"
#include "code\modules\mob\living\carbon\human\species_type\golems.dm"
#include "code\modules\mob\living\carbon\human\species_type\mothmen.dm"
#include "code\modules\mob\living\carbon\human\species_type\plasmamen.dm"
#include "code\modules\mob\living\carbon\human\species_type\podpeople.dm"
#include "code\modules\mob\living\carbon\human\species_type\shadowpeople.dm"
#include "code\modules\mob\living\carbon\human\species_type\skeletons.dm"
#include "code\modules\mob\living\silicon\robot\emote.dm"
#include "code\modules\mob\living\silicon\robot\robot_modules.dm"
#include "code\modules\mob\living\simple_animal\bot\deathsky.dm"
#include "code\modules\mob\living\simple_animal\hostile\cat_butcher.dm"
#include "code\modules\mob\living\simple_animal\hostile\retaliate\kangaroo.dm"
#include "code\modules\reagents\chemistry\reagents\other_reagents.dm"
#include "code\modules\reagents\chemistry\reagents\toxin_reagents.dm"
#include "code\modules\reagents\chemistry\recipes\others.dm"
#include "code\modules\reagents\chemistry\recipes\toxins.dm"
#include "code\modules\reagents\reagent_containers\bottle.dm"
#include "code\modules\reagents\reagent_containers\custompen.dm"
#include "code\modules\research\designs\AI_module_designs.dm"
#include "code\modules\research\designs\bluespace_designs.dm"
#include "code\modules\research\designs\mechfabricator_designs.dm"
#include "code\modules\research\designs\medical_designs.dm"
#include "code\modules\surgery\organs\tongue.dm"
#include "code\modules\uplink\uplink_items.dm"
#include "code\modules\vehicles\cars\thanoscar.dm"
#include "code\modules\vending\_vending.dm"
#include "code\modules\vending\autodrobe.dm"
#include "code\modules\vending\clothesmate.dm"
#include "code\modules\vending\wardrobes.dm"
#include "code\modules\surgery\advanced\bioware\cortex_folding.dm"
#include "code\modules\surgery\advanced\bioware\cortex_imprint.dm"
