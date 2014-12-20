library Blink initializer Init requires TimerUtils, ItemSystem /* v 1.0.0
**********************************************************************************
*
*   Blink Dagger Behaviour
*   --------------------------------
*
**********************************************************************************
    FUNCIONAMIENTO
        El item BLINK_ENABLED permite a las unidades hacer un "blink", que es moverse
        de la posición actual a la posición target.
        Cuando una unidad recibe daño de un héroe enemigo, los items BLINK_ENABLED
        deben deshabilitarse (reemplazarse por BLINK_DISABLED). Esto tiene un cooldown
        de 4 segundos, si no recive daño en ese tiempo, debe volver a colocarse el item
        original.
    CASOS BORDE
        - La unidad muere mientras tiene el blink deshabilitado
*********************************************************************************/

    define
        private BLINK_ENABLED  = 'I00U'
        private BLINK_DISABLED = 'I002'
        private BLINK_COOLDOWN = 4
        private BLINK_HASH_KEY = 100
    enddefine
    
    private struct ItemData
        item array i[6]
        integer length
        timer t
        unit u
    endstruct
    
    function BlinkReset takes ItemData Data returns nothing
        // Cambiamos los Disabled por Enabled
        loop
            exitwhen Data.length == 0
            set Data.length = Data.length-1
            call ReplaceItem(Data.u, Data.i[Data.length], BLINK_ENABLED)
            set Data.i[Data.length] = null
        endloop
        // Removemos la Data
        call RemoveSavedInteger(HT, GetHandleId(Data.u), BLINK_HASH_KEY)
        // Liberamos timer
        call ReleaseTimer(Data.t)
        // Leaks
        set Data.t = null
        set Data.u = null
        set Data.length = 0
        call Data.destroy()
    endfunction
    
    private function Expire takes nothing returns nothing
        local ItemData Data = GetTimerDataEx()
        if isUnitAlive(Data.u) then
            call BlinkReset(Data)
        endif
    endfunction

    private function ResetTimer takes unit u returns nothing
        local ItemData data
        if HaveSavedInteger(HT, GetHandleId(u), BLINK_HASH_KEY) then
            set data = LoadInteger(HT, GetHandleId(u), BLINK_HASH_KEY)
            call PauseTimer(data.t)
            call TimerStart(data.t, BLINK_COOLDOWN, false, function Expire)
        endif
    endfunction
    
    public function Removal takes unit u returns nothing
        local integer index=0
        local integer id=GetHandleId(u)
        local item blink
        local ItemData Data
        // Obtener instancia anterior guardada, si es que existe
        if HaveSavedInteger(HT,id,BLINK_HASH_KEY) then
            set Data = LoadInteger(HT,id,BLINK_HASH_KEY)
        // Crear nueva instancia
        else
            set Data        = ItemData.create()
            set Data.u      = u
            set Data.t      = NewTimerEx(Data)
            set Data.length = 0
            call SaveInteger(HT, id, BLINK_HASH_KEY, Data)
        endif
        // Cambiamos los Enabled por Disabled
        loop
            set blink = UnitItemInSlot(u,index)
            if GetItemTypeId(blink) == BLINK_ENABLED then
                set Data.i[Data.length] = ReplaceItem(u, blink, BLINK_DISABLED)
                set Data.length=Data.length + 1
            endif
            set index = index + 1
            exitwhen index == 6
        endloop
        // Comenzamos el Timer en caso de ser pertinente
        if Data.length > 0 then
            call PauseTimer(Data.t)
            call TimerStart(Data.t, BLINK_COOLDOWN, false, function Expire)
        endif
        set blink=null
    endfunction
    
    function BlinkRemoval takes unit blinkUnit,player damageSource,player blinkPlayer returns nothing
        if isHero(blinkUnit) and isUnitAlive(blinkUnit) and IsPlayerEnemy(damageSource,blinkPlayer) and damageSource != blinkPlayer and udg_team1[0]!= damageSource and udg_team2[0]!=damageSource and not isIllusion(blinkUnit) then
            // Si tiene BLINK_ENABLED, hay que cambiar los items y comenzar el timer
            if UnitCountItemsOfType(blinkUnit, BLINK_ENABLED) > 0 then
                call Removal(blinkUnit)
                return
            endif
            // Si tiene BLINK_DISABLED, hay que reiniciar el timer
            if UnitCountItemsOfType(blinkUnit, BLINK_DISABLED) > 0 then
                call ResetTimer(blinkUnit)
            endif
        endif
    endfunction

    /*********************************************************************************
    *
    *   Death Fix
    *   --------------------------------
    *   
    *   Cuando los heroes reviven, hay que reemplazar DISABLED_BLINK por los ENABLED_BLINK
    *
    **********************************************************************************/

    private function onHeroRevive takes nothing returns nothing
        unit reviving = GetTriggerUnit()
        if UnitCountItemsOfType(reviving, BLINK_DISABLED) > 0 then
            BlinkReset(LoadInteger(HT, GetHandleId(reviving), BLINK_HASH_KEY))
        endif
    endfunction

    private function Init takes nothing returns nothing
        trigger t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ( t, EVENT_PLAYER_HERO_REVIVE_FINISH )
        TriggerAddAction( t, function onHeroRevive )
    endfunction 

endlibrary