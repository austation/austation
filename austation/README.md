# AuStation Custom Directory
This directory exists to house custom code changes that can be properly seperated from the codebase and placed here. All files that can be placed here should. The includes.dm file should be used to tick new code files to avoid messing up the dme. Any code changes outside this folder should be made with this comment for one line changes `// austation -- <reason>` and `//austation begin -- <reason>` & `//austation end` for multiline changes. Both of these are *shamelessly* stolen from HippieStation.

## Roundend Sounds
Be advised, any new roundend sounds cannot be modularized due to the way the code is setup. Please place any new roundend sounds in `sound/roundend`. I will be incredibly surprised if this results in conflicts, as we are the only ones changing those files.
