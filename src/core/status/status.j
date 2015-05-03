library Status initializer Init  requires AbilityPreload, CasterSystem, OrderCreep /* v1.1.1.0
*************************************************************************************
*
*   Con Status podrás agregar estados (stun, silence, invisibility, hex y muchos más)
*   a las unidades muy fácilmente.
*
*************************************************************************************
*
*   Estados
*
*       STATUS_STUN
*           -   Stun a la unidad que se agregue este estado
*
*       STATUS_SILENCE
*           -   La unidad que tenga este estado no podrá lanzar spells
*
*       STATUS_DISARM_BOTH
*           -   Las unidades con este estado no podrán atacar (melee ni rango)
*
*       STATUS_DISARM_MELEE
*           -   Las unidades que ataquen melee no podrán atacar
*
*       STATUS_DISARM_RANGE
*           -   Las unidades que ataquen a distancia no podrán atacar
*
*       STATUS_ENTANGLE
*           -   Red, no se pueden mover pero si atacar y lanzar spells
*
*       STATUS_INVISIBILITY
*           -   Vuelve invisible a la unidad que se le de este estado
*
*       STATUS_GHOST
*           -   Similar a STATUS_INVISIBILITY
*
*       STATUS_DOOM
*           -   Las unidades con este estado no pueden lanzar ni aprender spells
*
*       STATUS_SPELL_IMMUNITY
*           -   Vuelve inmune a ataques mágicos a la unidad que se le de este estado
*
*       STATUS_HEX
*           -   Transforma en una oveja/rana/etc a la unidad que tenga este estado
*               haciendo que la misma no pueda atacar ni lanzar habilidades
*
*       STATUS_NEVER_MISS
*           -   La unidad a la que se le dé este estado nunca miss un golpe
*
*       STATUS_ALWAYS_MISS
*           -   La unidad con este estado siempre hará miss en sus ataques
*
*       STATUS_UNTOUCHABLE
*           -   La unidad que tenga este estado tendrá 100% de evasión
*
*       STATUS_BANISH
*           -   Inmune a golpes físicos pero no mágicos
*
*       STATUS_PHASE
*           -   Mismo efecto que Windwalk solo que no hace invisible
*
*       STATUS_RESISTANT_SKIN
*           -   Reduce la duración de habilidades negativas y hace inmune
*               a ciertas habilidades
*
*       STATUS_REFLECT_PIERCING
*           -   Reduce el daño de ataques tipo Piercing y de ataques mágicos
*
*       STATUS_DISABLE
*           -   Como pausear una unidad, solo que no esconde los iconos
*
*       STATUS_INVULNERABLE
*           -   Vuelve invulnerable ante todos los ataques a la unidad
*               que tenga este estado
*
*       STATUS_PAUSE
*           -   Pausea la unidad que tenga este estado, haciendo que
*               no se pueda mover ni atacar
*
*       STATUS_HIDE
*           -   Esconde a la unidad que tenga este estado
*
*       STATUS_UNPATH
*           -   Saca las colisiones a la unidad que posea este estado
*
*************************************************************************************
*
*   Funciones
*
*       function Status_Add takes integer status, unit u returns nothing
*           -   Agrega el estado a la unidad
*
*       function Status_Remove takes integer status, unit u returns nothing
*           -   Remueve el estado a la unidad
*
*       function Status_Has takes integer status, unit u returns boolean
*           -   Devuelve true si la unidad tiene el estado
*
*************************************************************************************
*
*   Créditos
*
*       Enteramente a Jesus4Lyf, yo solamente optimicé su trabajo
*       muZk
*
*************************************************************************************
*
*   CONFIGURABLE
*
*/
    define
    {
        BUFF_ENTANGLE_AIR = 'B506'
    }
/*********************************************************************************
*
*   GLOBALS
*
*/
    define
    {
        STATUS_STUN                        = 1
        STATUS_SILENCE                     = 2
        STATUS_DISARM_BOTH                 = 3

        STATUS_DISARM_MELEE                = 4
        STATUS_DISARM_RANGE                = 5
        STATUS_ENTANGLE                    = 6
        STATUS_INVISIBILITY                = 7
        STATUS_GHOST                       = 8
        STATUS_DOOM                        = 9
        STATUS_SPELL_IMMUNITY              = 10
        STATUS_HEX                         = 11
        STATUS_NEVER_MISS                  = 12
        STATUS_ALWAYS_MISS                 = 13
        STATUS_UNTOUCHABLE                 = 14
        STATUS_BANISH                      = 15
        STATUS_PHASE                       = 16
        STATUS_RESISTANT_SKIN              = 17
        STATUS_REFLECT_PIERCING            = 18
        STATUS_DISABLE                     = 19

        STATUS_INVULNERABLE                = 20
        STATUS_PAUSE                       = 21
        STATUS_HIDE                        = 22
        STATUS_UNPATH                      = 23
    }
        
    globals
        private integer array ABILITY
        private integer array BUFF
        private integer array ORDER
        private hashtable hashTable                         = InitHashtable()
    endglobals
    
/************************************************************************************
*
*   CONFIGURABLE
*
*/
    private function Load takes nothing returns nothing
        set ABILITY[STATUS_STUN]            = 'A0JO'
        set ABILITY[STATUS_SILENCE]         = 'A0KT'
        set ABILITY[STATUS_DISARM_BOTH]     = 'A0JN'
        //set ABILITY[STATUS_DISARM_MELEE]    = 'A503'
        //set ABILITY[STATUS_DISARM_RANGE]    = 'A504'
        //set ABILITY[STATUS_ENTANGLE]        = 'A505'
        //set ABILITY[STATUS_INVISIBILITY]    = 'A507'
        //set ABILITY[STATUS_GHOST]           = 'A508'
        set ABILITY[STATUS_DOOM]              = 'A0LJ'
        //set ABILITY[STATUS_SPELL_IMMUNITY]  = 'A50B'
        //set ABILITY[STATUS_HEX]             = 'A50C'
        //set ABILITY[STATUS_NEVER_MISS]      = 'A50F'
        //set ABILITY[STATUS_ALWAYS_MISS]     = 'A50H'
        //set ABILITY[STATUS_UNTOUCHABLE]     = 'A50J'
        //set ABILITY[STATUS_BANISH]          = 'A50K'
        //set ABILITY[STATUS_PHASE]           = 'A50L'
        //set ABILITY[STATUS_RESISTANT_SKIN]  = 'A50Q'
        //set ABILITY[STATUS_REFLECT_PIERCING]= 'A50S'
        //set ABILITY[STATUS_DISABLE]         = 'A50T'
        
        set BUFF[STATUS_STUN]                 = 'B02R'
        set BUFF[STATUS_SILENCE]              = 'BNsi'
        set BUFF[STATUS_DOOM]                 = 'B04D'
        set BUFF[STATUS_DISARM_BOTH]          = 'B02B'
        //set BUFF[STATUS_DISARM_MELEE]       = 'B503'
        //set BUFF[STATUS_DISARM_RANGE]       = 'B504'
        //set BUFF[STATUS_ENTANGLE]           = 'B505'
        //set BUFF[STATUS_HEX]                = 'B50C'
        //set BUFF[STATUS_BANISH]             = 'B50K'
        //set BUFF[STATUS_PHASE]              = 'B50L'
        //set BUFF[STATUS_DISABLE]            = 'B50T'
        
        set ORDER[STATUS_STUN]                = 852231
        set ORDER[STATUS_SILENCE]             = 852668
        set ORDER[STATUS_DISARM_BOTH]         = 852585
        //set ORDER[STATUS_DISARM_MELEE]      = 852585
        //set ORDER[STATUS_DISARM_RANGE]      = 852585
        //set ORDER[STATUS_ENTANGLE]          = 852106
        set ORDER[STATUS_DOOM]              = 852583
        //set ORDER[STATUS_HEX]               = 852502
        //set ORDER[STATUS_BANISH]            = 852486
        //set ORDER[STATUS_PHASE]             = 852129
        //set ORDER[STATUS_DISABLE]           = 852252
    endfunction
/********************************************************************************
*/

    private boolean disarmFix(unit u){
        return GetOwningPlayer(u)==udg_team1[0] or GetOwningPlayer(u)==udg_team2[0]
    }
    
    public function Has takes unit u,integer status returns boolean
        return LoadInteger(hashTable, GetHandleId(u), status) > 0
    endfunction
    
    public function Add takes unit u,integer status returns nothing
        local integer id = GetHandleId(u)
        local integer level = LoadInteger(hashTable, id, status) + 1
        
        call SaveInteger(hashTable, id, status, level)
        
        if (level > 0) then
            if (status == STATUS_INVULNERABLE) then
                call SetUnitInvulnerable(u, true)
            elseif (status == STATUS_PAUSE) then
                call PauseUnit(u, true)
            elseif (status == STATUS_HIDE) then
                call ShowUnit(u, false)
            elseif (status == STATUS_UNPATH) then
                call SetUnitPathing(u, false)
            elseif (status == STATUS_PHASE) then
                call SetPlayerAbilityAvailable(GetOwningPlayer(u), ABILITY[status], true)
                
                if (UnitAddAbility(u, ABILITY[status])) then
                    call UnitMakeAbilityPermanent(u, true, ABILITY[status])
                    call IssueImmediateOrderById(u, ORDER[status])
                endif
                
                call SetPlayerAbilityAvailable(GetOwningPlayer(u), ABILITY[status], false)
            else
                if (ORDER[status] == 0) then
                    call UnitAddAbility(u, ABILITY[status])
                    call UnitMakeAbilityPermanent(u, true, ABILITY[status])
                else
                    CasterCast(u, ABILITY[status], ORDER[status])
                    // DISARM CREEPS FIX
                    if status == STATUS_DISARM_BOTH and disarmFix(u)==true then
                        call IssueImmediateOrder(u,"stop")
                    endif
                endif
            endif
        endif
    endfunction
    
    public function Remove takes unit u,integer status returns nothing
        local integer id     = GetHandleId(u)
        local integer level  = LoadInteger(hashTable, id, status) - 1

        // We don't want to do anything else if there is nothing stored
        if not Has(u, status) then
            return
        endif
        
        call SaveInteger(hashTable, id, status, level)

        if level == 0 then
            if (status == STATUS_INVULNERABLE) then
                call SetUnitInvulnerable(u, false)
            elseif (status == STATUS_PAUSE) then
                call PauseUnit(u, false)
            elseif (status == STATUS_HIDE) then
                call ShowUnit(u, true)
            elseif (status == STATUS_UNPATH) then
                call SetUnitPathing(u, true)
            elseif (status == STATUS_PHASE) then
                call UnitRemoveAbility(u, BUFF[status])
            else
                if (ORDER[status] == 0) then
                    call UnitMakeAbilityPermanent(u, false, ABILITY[status])
                    call UnitRemoveAbility(u, ABILITY[status])
                endif
                
                if (BUFF[status] != 0) then
                    call UnitRemoveAbility(u, BUFF[status])
                    
                    // DISARM CREEPS FIX
                    if status == STATUS_DISARM_BOTH and disarmFix(u)==true then
                        call OrderCreep(u)
                    endif
                    
                    // We also have to remove the air tangle buff
                    if (status == STATUS_ENTANGLE) then
                        call UnitRemoveAbility(u, BUFF_ENTANGLE_AIR)
                    endif
                endif
            endif
        endif
    endfunction
    
    /**
     * Limpiamos todos los estados a una unidad
     * 
     * @param unit whichUnit
     */ 
    public function Clear takes unit whichUnit returns nothing
        local integer status = STATUS_UNPATH // ultimo estado
        local integer id = GetHandleId(whichUnit)
        
        loop
            exitwhen status == 0
            
            if Has(whichUnit, status) then
                call SaveInteger(hashTable, id, status, 1)
                call Remove(whichUnit, status)
            endif

            set status = status - 1
        endloop
        
        call FlushChildHashtable(hashTable, id)
    endfunction
    
    private function OnDeath takes nothing returns boolean
        call Clear(GetTriggerUnit())
        return false
    endfunction
    
    private function Init takes nothing returns nothing
        local trigger onDeath = CreateTrigger()
        local integer i = 1
        local integer n = 0
        
        call TriggerRegisterAnyUnitEventBJ(onDeath, EVENT_PLAYER_UNIT_DEATH)
        call TriggerAddCondition(onDeath, Condition(function OnDeath))
        
        call Load()
    
        loop
            exitwhen ABILITY[i] == 0
            
            call AbilityPreload(ABILITY[i])
            
            if (ORDER[i] == 0) then
                loop
                    exitwhen n > bj_MAX_PLAYERS
                    call SetPlayerAbilityAvailable(Player(n), ABILITY[i], false)
                    set n = n + 1
                endloop
                set n = 0
            endif
            
            set i = i + 1
        endloop
        
        set onDeath = null
    endfunction
endlibrary