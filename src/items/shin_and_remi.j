scope ShinAndRemi initializer init{

    define{
        SHIN_MELEE_SPELLBOOK = 'A0HX' // 20 DMG, 60%
        SHIN_RANGE_SPELLBOOK = 'A0KO' // 10 DMG, 60%
        REMI_MELEE_SPELLBOOK = 'A0HY' // 40 DMG, 70%
        REMI_RANGE_SPELLBOOK = 'A0KQ' // 20 DMG, 70%
        SHIN_ABILITY         = 'A03M'
    }

    private bool onDrop(){
        unit u = GetTriggerUnit()
        integer id = GetItemTypeId(GetManipulatedItem())

        if id == ITEM_REMI and CountItemsOfTypeById(u, id) == 1 then
            RemoveAbility(u,REMI_RANGE_SPELLBOOK)
            RemoveAbility(u,REMI_MELEE_SPELLBOOK)
            debug BJDebugMsg("[-Remi]")
        elseif id == ITEM_SHIN_GUARDS and CountItemsOfTypeById(u, id) == 1 then
            RemoveAbility(u, SHIN_RANGE_SPELLBOOK)
            RemoveAbility(u, SHIN_MELEE_SPELLBOOK)
            debug BJDebugMsg("[-Shin]")
        endif

        u=null
        return false
    }

    private bool onPick(){
        unit u = GetTriggerUnit()
        boolean ranged = IsUnitType(u,UNIT_TYPE_RANGED_ATTACKER)
        boolean melee  = !ranged
        boolean shin   = GetItemTypeId(GetManipulatedItem())==ITEM_SHIN_GUARDS
        boolean remi   = GetItemTypeId(GetManipulatedItem())==ITEM_REMI
        boolean result = false

        if(IsHero(u)){

            if(shin and ranged){
                result = AddAbility(u, SHIN_RANGE_SPELLBOOK)
            } elseif(shin and melee){
                result = AddAbility(u, SHIN_MELEE_SPELLBOOK)
            } elseif(remi and ranged){
                result = AddAbility(u, REMI_RANGE_SPELLBOOK)
            } elseif(remi and melee){
                result = AddAbility(u, REMI_MELEE_SPELLBOOK)
            }

            static if DEBUG_MODE then
            	if result then
            		if shin and ranged then
            			BJDebugMsg("[+Shin] ranged")
            		elseif shin and melee then
            			BJDebugMsg("[+Shin] melee")
            		elseif remi and ranged then
            			BJDebugMsg("[+Remi] ranged")
            		elseif remi and melee then
						BJDebugMsg("[+Remi] melee")
            		endif
            	endif
            endif

        }

        u = null

        return false
    }

    private void init(){
        call GT_RegisterPlayerEventAction(EVENT_PLAYER_UNIT_PICKUP_ITEM, function onPick)
        call GT_RegisterPlayerEventAction(EVENT_PLAYER_UNIT_DROP_ITEM, function onDrop)
    }

}