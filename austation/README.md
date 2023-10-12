# AuStation Modular Resources Folder
This directory is responsible for housing all austation development resources possible, to minimise the merge conflicts associated with maintaining custom features on our codebase.

## Code
Wherever possible, you should make code changes in this folder.

This is trivial for things like variable changes, where you can just write out the type, and the variable you want to change.

It is also trivial to perform simple proc overrides in the same way.

This is because the default behaviour when you "tick" a file in VSCode is that it will be added to the "post includes" section of `austation.dme`. This will cause your changes to override the code in the upstream code.

Where things get complicated is when you need to modify a small section of a very large upstream proc, or when `. = ..()` or `return ..()` (parent proc calls) get involved. There are a few hacks you may be able to use to get around this, such as the pre-includes section in `austation.dme`.

Always seek some advice in the coding chat in our Discord if you have trouble.

In some cases it may not be possible to implement code changes in an acceptable way in the modular code folder. If that is the case, you ***MUST*** comment all code changes to upstream code with the following rules:

* For one-line changes *only*, you must comment `// austation -- explanation of changes here` at the end of the line, with a *brief* description of the purpose of the changes.
* For multi-line changes, you must comment `// austation begin -- explanation of changes here` on the *line above* where your changes begin, and then `// austation end` on the *line below* where your changes end.
* When deleting code from upstream, you must not remove the code entirely, rather you must "comment it out" using multi-line comments. To do this, on the *line above* the code you want to remove, comment thus: `/* austation begin -- explanation of code removal here`, then on the *line below* where the removal ends, comment: `austation end */` to close the multi-line comment.

You MUST make these comments for every change in a file. Only commenting some of the changes lines is insufficient. You MAY however, use multi-line comments to cover several separated changes, as long as using single line comments would be easier.

## Icons
Icons MUST be modularised into this folder. Any pull request that modifies bee files without explicit approval from codebase staff will be blocked until icon changes are moved to this folder. Icons are updated frequently upstream, and conflicts with icon files are notoriously difficult to deal with.

You will need to set the correct icon file and state in code, to use your modular icon file(s), either in the object definition, or in a proc depending on your requirements, using the `icon` and `icon_state` variables.

As a rule of thumb, you ***should not*** copy icon files directly from the upstream icons folder, and point a whole parent type at it, as this means any icon updates from upstream will not be applied until your modular file is manually updated, which is just as bad as a merge conflict in most respects.

You ***should*** create icon files here with **ONLY** the icon states you want to modify (or that are required for your change to work without significant hacks), and make sure every other unmodified state will point towards the original file to minimise maintainance work for repo staff.

## Sounds
Sounds are much easier to deal with than code and icons, as they do not accomodate multiple states; every sound file has one sound and is used separately.

You should still create all sounds here however, to make keeping track of changes easier for repo staff.
