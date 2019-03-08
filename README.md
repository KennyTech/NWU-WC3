NWU
===

Creators: Kroom, MuzK, Kenny  
A Custom Game Mod enjoyed by hundreds for the popular RTS game Warcraft 3  
Naruto Wars Unlimited (http://form.narutowarsunlimited.com/)  
It is a MOBA (hero arena) inspired from the game DoTA, with character origins from the animated Japanese cartoon Naruto.  
2009 - 2018  

# How to change version

Two simple steps:

1. In WorldEdit, go to Scenerario -> Map Description. Then change "Name" field to whatever you want. Example: NWU |cffff8c001.3.9h|r. Then Save map.
2. Open exported/Constants/war3mapSkin.txt and change UPKEEP_NONE=|cff99ccffv1.3.9h|r (should be on line 3). Save file.

# Game Constants

"Gameplay Constants" and "Game Interface"  should be changed using the files inside exported/Constants foolder. Thanks to this, we can track the changes in constants.

There is a script inside map that will merge map constants with the constans inside exported/Constants foolder.

# How to enable/disable hero for selection

1. Open src/core/mechanics/hero_preload.j
2. Search the hero which you want to enable/disable
	- Enabling:  Set udg_HeroIsAvailable[HERO_INDEX] = true
	- Disabling: Set udg_HeroIsAvailable[HERO_INDEX] = false

This will enable/disable the hero for sd, repick.

To add or remove a hero in a tavern, you have to go to modify "Sellunits" attribute of Taverns using WorldEdit.
If you enable or disable a hero, *don't forget* to edit the tavern too!

# How to enable/disable hero for testing

1. Open src/lib/testers.j
2. Modify **command2heroId** function.

# Add or remove testers

1. Open src/lib/testers.j
2. Search "string array testers" line
3. Add or remove testers using testers array. Remember to update the TESTERS_LENGTH variable.

# How to add a new hero

1. Create the unit hero as usual in WorldEdit, and lets say that the *rawcode* is **XXXX**.
2. You should create heroe triggers in ```src/heroes/new_hero_name folder```. The ```scope``` of an ability shouln't define the ```initializer``` function. Instead of the classic ```initializer init``` where ```init``` function is **private**, make it **public** and name it ```Init```. Now you can call this initializer from outsite the scope: ```call SCOPE_NAME_Init```. Note: This is important for step 6.
3. Run the import script in the root path: ```node import.js``` (it will include your hero files in map).
4. Save map. You may have errors in this step, just edit your hero files to fix errors and Save Again.
5. Edit ```src/globals/heroes.j``` adding a pair ```NAME = 'XXXX'``` inside the define block. Name will be the indetifier of the hero's *rawcode* in other triggers. 
6. ```Edit core/mechanics/hero_pick.j``` file. Change the ```TurnOnOffHeroTriggers``` adding another ```elseif UnitType == NAME then ```. Inside the block, call all initializer functions (defined in step 2) using ```ExecuteFunc```. If the scope of an ability is named ```Ability``` and the initializer function is ```Init```, just ```call ExecuteFunc("Ability_Init")```. This must be done for all the hero trigger abilities.
7. Edit ```src/core/mechanics/hero_preload.j``` file by adding the new hero. Just copy the last record and change the necesary stuff. Its self explanatory. Remember to update ```udg_hero_amount``` variable to match the last index of the added unit.
8. Open ```src/exported/Constants/war3mapMisc.txt``` and go to the bottom. You gonna see a ```[HERO]``` attribute. Add to the list the rawcode of the new hero. *Disclaimer: I'm not sure if it is necessary.*
9. Go to **WorldEdit** and open **Units**. Select a **Tavern** and add the new hero in ```Sellunits``` field. Update the **Requires** field of the hero unit to **R000** if you want it to be available to *Konoha* (North Team). **R002** in other case.

# Testing

Well, war3 doesn't have a testing suit, but sometimes its usefull to just put messages. There are two helpers that are loaded only in **debug mode**: ```Test_Success(string msg)``` and ```Test_Error(string msg)``` they just print msg with green and red, respectively. Maybe we can add more testing functions in the future.

# Conventions

## Abilitites

- 1 ability, 1 scope. 
- File names are in *snake_case* and scope names in *CamelCase*. For example, Killer bee's lariat scope name is BeeLariat and file name is bee_lariat.j
- For constants use **cjass** define functions.
- By level configuration such damage, durations, etc. should be defined inside a define function. Example:
Instead of having this:
	``` 
		// Ability
		Damage_Spell(source, target, lvl*25)
	```
Do this:
	``` 
		// Configuracion section ...
		define SpellDamage(lvl) = lvl*25
		// Ability
		Damage_Spell(source, target, SpellDamage(lvl)) 

	```
It helps to keep everything configurable in config. section.
- Instead of using ``` scope NAME initializer Init ``` and ``` private function Init ... ``` do ```scope NAME``` and ``` public function Init ... ```. Refer to "How to add a Hero" section to learn how to call the Init function when needed.

# TODO
Finish this readme :)
