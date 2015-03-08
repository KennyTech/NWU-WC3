scope Kamui

    define
        Kamui_ABIL_ID                = 'A0LB' // A0L1 OLD
        Kamui_BUFF_ID                = 'B04A' // DUMMY AURA BUFF
        Kamui_KEY                    = 130
        private DUMMY_VISION         = 'h02F' // Dummy Vision
        private DUMMY_ABIL_ID        = 'A0LE' // This ability gives the Kamui_BUFF_ID , dummy tornado aura
        private BLOODLUST_ID         = 'A0L2'
        private DURATION(level)      = 3+2*level
        private DAMAGE_RETURN(level) = 7.5+5*level
        private STACK(level)         = 1+2*level
        private hasKamuiBuff(u)      = GetUnitAbilityLevel(u,'B04A') > 0 
    enddefine
    
    private void changeDummyPosition(){
        integer h=GetHandleId(GetExpiredTimer())
        unit caster=getUnit(h,0)
        unit dummy=getUnit(h,1)
        if hasKamuiBuff(caster) then
            SetUnitX(dummy,GetUnitX(caster))
            SetUnitY(dummy,GetUnitY(caster))
        else
            KillUnit(dummy)
            ReleaseTimerEx()
        endif
        caster=null
        dummy=null
    }

    private bool onCast(){
        unit caster=GetTriggerUnit()
        int level=GetUnitAbilityLevel(caster,Kamui_ABIL_ID)
        timer t=NewTimer()
        integer h=GetHandleId(t)
        SetInt(GetHandleId(caster),Kamui_KEY,STACK(level))
        UnitAddAbilityTimed(caster,DUMMY_ABIL_ID,DURATION(level))
        setUnit(h,0,caster)
        setUnit(h,1,CreateUnit(GetOwningPlayer(caster),DUMMY_VISION,GetUnitX(caster),GetUnitY(caster),0))
        TimerStart(t,0.1,true,function changeDummyPosition)
        caster=null
        t=null
        return false
    }
    
    private void onDamage(unit target,unit source,real damage){
        if hasKamuiBuff(target) then
            if GetUnitAbilityLevel(target,BranchArmor_BUFF_ID) > 0 then
                call Damage_Spell(target,source,DAMAGE_RETURN(GetUnitAbilityLevel(target,BranchArmor_ABIL_ID)))
            endif
            // DamageSYS--
            
            if (IsUnitType(source, UNIT_TYPE_HERO) || IsUnitType(source, UNIT_TYPE_STRUCTURE))
            {
                int h=GetHandleId(target)
                int stack=getInt(h,Kamui_KEY)-1
                if(stack>=0){
                    setInt(h,Kamui_KEY,stack)
                    DestroyEffect(AddSpecialEffectTarget("war3mapImported\\BlackBlink.mdx",target,"chest"))
                    Damage_BlockAll()
                }
            }
        endif
    }

    public void Init(){
        SpellCast(Kamui_ABIL_ID)
        Damage_Register(onDamage)
        AbilityPreload(DUMMY_ABIL_ID)
    }
endscope