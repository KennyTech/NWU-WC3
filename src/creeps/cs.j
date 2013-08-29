scope CS initializer Init

    globals
        private integer SIZE=0
    endglobals

    private function AddExpFilter takes nothing returns boolean
        if GetWidgetLife(GetFilterUnit())>0.405 and IsUnitEnemy(GetFilterUnit(),GetTriggerPlayer()) and IsUnitType(GetFilterUnit(),UNIT_TYPE_HERO) then
            set SIZE=SIZE+1
            return true
        endif
        return false
    endfunction
    
    private function AddExp takes nothing returns nothing
        if IsUnitIdType(GetUnitTypeId(GetEnumUnit()), UNIT_TYPE_MELEE_ATTACKER) then
            call AddHeroXP(GetEnumUnit(),36/SIZE,true)
        else
            call AddHeroXP(GetEnumUnit(),18/SIZE,true)
        endif
    endfunction

    private function IncreaseCS takes nothing returns boolean
        local unit u=GetTriggerUnit()
        local integer id
        local player p
        if IsUnitType(u,UNIT_TYPE_STRUCTURE) == false and GetPlayerController(GetTriggerPlayer()) != MAP_CONTROL_USER and GetUnitAbilityLevel(u,'Aloc')==0 then
            set p=GetOwningPlayer(GetKillingUnit())
            set id=GetPlayerId(p)+1
            if IsUnitEnemy(u,p) then
                set udg_PlayerCSKilled[id]=udg_PlayerCSKilled[id]+1
            else
                set udg_PlayerCSDenied[id]=udg_PlayerCSDenied[id]+1
                set SIZE=0
                call GroupEnumUnitsInRange(ENUM,GetUnitX(u),GetUnitY(u),1200,Condition(function AddExpFilter))
                call ForGroup(ENUM,function AddExp)
            endif
            call MultiboardTitle(p)
            set p=null
        endif
        set u=null
        return false
    endfunction

    private void Init() {
        GT_RegisterPlayerEventAction(EVENT_PLAYER_UNIT_DEATH,function IncreaseCS)
    }

endscope