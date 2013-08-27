scope Shark
    
    define{
        private DAMAGE(lvl) = 75*lvl
    }
    
    public function Damage takes nothing returns nothing
        local timer t=GetExpiredTimer()
        local integer id=GetHandleId(t)
        local unit u=LoadUnitHandle(HT,id,2)
        call UnitDamageStunArea(u,LoadReal(HT,id,0),LoadReal(HT,id,1),250,DAMAGE(GetUnitAbilityLevel(u,'A0H7')),DAMAGE_SPELL,null,2)
        call ReleaseTimer(t)
        set u=null
        set t=null
    endfunction

    public function onSpell takes nothing returns boolean
        local real x=GetSpellTargetX()
        local real y=GetSpellTargetY()
        local player p=GetTriggerPlayer()
        local timer t=NewTimer()
        local integer id=GetHandleId(t)
        local real i=0
        local unit Dummy
        local real a
        local real b
        call EnumDestructablesInCircle(250,x,y,function KillDestructableEnum)
        call DestroyEffect(AddSpecialEffect("Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl",x,y))
        loop
            exitwhen i == 5
            set a=198+i*72
            set b=(18+i*72)*bj_DEGTORAD
            set Dummy=CreateUnit(p,'h01H',x+300*Cos(b),y+300*Sin(b),a)
            call SetUnitVertexColor(Dummy,255,255,255,150)
            call SetUnitTimeScale(Dummy,3)
            call SetUnitAnimationByIndex(Dummy,1)
            set a = a*bj_DEGTORAD
            call CreateProj(Dummy,Dummy,GetUnitX(Dummy)+250*Cos(a),GetUnitY(Dummy)+250*Sin(a),100,600,0,true,0,0,0,0)
            call UnitApplyTimedLife(Dummy,'BTLF',0.5)
            set i=i+1
        endloop
        call SaveReal(HT,id,0,x)
        call SaveReal(HT,id,1,y)
        call SaveAgentHandle(HT,id,2,GetTriggerUnit())
        call TimerStart(t,0.5,false,function Damage)
        set t=null
        set Dummy=null
        return false
    endfunction
    
    public function Init takes nothing returns nothing
        call GT_RegisterSpellEffectEvent('A0H7',function onSpell)
    endfunction
endscope