library CasterSystem initializer init requires TimerUtils

    globals
        private group CasterGroup
    endglobals
    
    define DUMMY_ID = 'DUMY'
    
    function GetCaster takes nothing returns unit
        return udg_CASTER
    endfunction
    
    private nothing resetCaster(integer abilId){
        UnitRemoveAbility(udg_CASTER,abilId)
        UnitResetCooldown(udg_CASTER)
        SetUnitOwner(udg_CASTER,Player(15),false)
    }
    
    nothing AddAbilityLevel(unit m,integer abilId,integer lvl){
        UnitAddAbility(m,abilId)
        SetUnitAbilityLevel(m,abilId,lvl)
    }

    nothing CasterCastTarget (unit m,integer abilId,integer order,integer level,player owner){
        AddAbilityLevel(udg_CASTER ,abilId, level)
        if(owner != null){
            SetUnitOwner(udg_CASTER,owner,false)
        }
        IssueTargetOrderById(udg_CASTER ,order,m)
        resetCaster(abilId)
    }
    
    nothing CasterCastPoint(real x,real y,integer abilId,integer order,integer level,player owner){
        unit u=CreateUnit(owner,'u00H',x,y,0)
        AddAbilityLevel(u,abilId,level)
        IssuePointOrderById(u,order,x,y)
        UnitApplyTimedLife(u,'BTLF',20)
        u=null
    }
    
    define
        CasterCast(t,a,o) = CasterCastTarget(t,a,o,1,null)
        CasterCast(t,a,o,l) = CasterCastTarget(t,a,o,l,null) 
        CasterCast(t,a,o,l,p) = CasterCastTarget(t,a,o,l,p)
        
        CasterCastXY(x,y,a,o,p) = CasterCastPoint(x,y,a,o,1,o)
        CasterCastXY(x,y,a,o,l,p) = CasterCastPoint(x,y,a,o,l,p)
    enddefine
    
    function CasterCastOwner takes player owner,unit m,integer abilId,string order,integer lvl returns nothing
        local unit caster = FirstOfGroup(CasterGroup)
        if caster==null then
            set caster = CreateUnit(owner,DUMMY_ID,0,0,0)
        else
            call SetUnitOwner(caster,owner,false)
        endif
        call UnitAddAbility(caster,abilId)
        call SetUnitAbilityLevel(caster,abilId,lvl)
        call IssueTargetOrder(caster ,order,m)
        call UnitRemoveAbility(caster,abilId)
        call UnitResetCooldown(caster)
        call SetUnitOwner(caster,Player(15),false)
        call GroupAddUnit(CasterGroup,caster)
        set caster = null
    endfunction
    function NewCaster takes nothing returns unit
        if FirstOfGroup(CasterGroup)==null then
            return CreateUnit(Player(15),DUMMY_ID,0,0,0)
        endif
        return FirstOfGroup(CasterGroup)
    endfunction
    function ReleaseCaster takes unit caster returns nothing
        call UnitResetCooldown(caster)
        call SetUnitOwner(caster,Player(15),false)
        call GroupAddUnit(CasterGroup,caster)
    endfunction
    private nothing init(){
        set udg_CASTER = CreateUnit(Player(15),DUMMY_ID,0,0,0)
        set CasterGroup = CreateGroup()
        call RemoveUnit(CreateUnit(udg_team1[0],'e00L',0,0,0))//Effect preload
        call SetHeroLevel(udg_CASTER,6,false)
    }
    
endlibrary