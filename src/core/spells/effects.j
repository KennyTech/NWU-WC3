library Effects requires Status1, TerrainPathability/* v1.0.0.0
*************************************************************************************
*
*   Just a random library to add effects
*
*************************************************************************************
*
*   Funciones
*
*       function addEffectEx takes integer unit_id, real x, real y, real z, real a,r eal time, player p returns unit
*           -   Crea una unidad dummy de tipo unit_id, en la posición (x,y,z) mirando hacia el ángulo a (radian)
*               para el player p. La unidad vive time segundos.
*
*       function addEffect takes unit_id, real x, real y, real z, real a, real time, player p returns unit
*           -   Wrapper de nombre para addEffectEx
*
*       function addEffect takes unit_id, real x, real y, real z, real a, real time returns unit
*           -   Overload para addEffect. Player corresponde a Player(15)
*
*       function addEffect takes unit_id, real x, real y, real a, real time returns unit
*           -   Overload para addEffect. Player corresponde a Player(15) y se asume que z = 0
*
*       function addEffect takes unit_id, real x, real y, real time returns unit
*           -   Overload para addEffect. Player corresponde a Player(15), se asume que z = 0 y que a = 0
*
*       function addEffect takes unit_id, target, real time returns unit
*           -   Overload para addEffect. Player corresponde a Player(15), se asume que z = 0 y que a = 0, y que (x,y)
*               corresponde a la posición del target
*
*************************************************************************************/

    // addEffectEx: Places a dummy unit 

    unit addEffectEx(integer unit_id,real x,real y,real z,real a,real time,player p){
        bj_lastCreatedUnit=CreateUnit(p,unit_id,x,y,a*bj_RADTODEG)
        UnitApplyTimedLife(bj_lastCreatedUnit,'BTLF',time)
        if(z > 0.0){
            FlyTrick(bj_lastCreatedUnit)
            SetUnitFlyHeight(bj_lastCreatedUnit,z,0)
        }
        return bj_lastCreatedUnit
    }
    
    define
        addEffect(unit_id,x,y,z,a,time,p) = addEffectEx(unit_id,x,y,z,a,time,p)
        addEffect(unit_id,x,y,z,a,time) = addEffectEx(unit_id,x,y,z,a,time,Player(15))
        addEffect(unit_id,x,y,a,time) = addEffectEx(unit_id,x,y,0.0,a,time,Player(15))
        addEffect(unit_id,x,y,time) = addEffectEx(unit_id,x,y,0.0,0.0,time,Player(15))
        addEffect(unit_id,target,time) = addEffectEx(unit_id,GetUnitX(target),GetUnitY(target),0.0,0.0,time,Player(15))
    enddefine
    
    // timedEffectEx: Add a Timed Effect to @u
    
    private nothing timedEffectEnd(){
        DestroyEffect(GetEffect(GetHandleId(GetExpiredTimer()),0))
        ReleaseTimerEx()
    }
    
    nothing timedEffectEx(unit u,string s,real time,string attach){
        timer t=NewTimer()
        SetEffect(GetHandleId(t),0,AddSpecialEffectTarget(s,u,attach))
        TimerStart(t,time,false,function timedEffectEnd)
        t=null
    }
    
    nothing timedEffectXY(string s,real x,real y,real time){
        timer t=NewTimer()
        SetEffect(GetHandleId(t),0,AddSpecialEffect(s,x,y))
        TimerStart(t,time,false,function timedEffectEnd)
        t=null
    }
    
    define{
        timedEffect(s,t,u,a) = timedEffectEx(s,t,u,a)
        timedEffect(s,t,u) = timedEffectEx(s,t,u,"chest")
    }
    
    // This thing is MAGIC
    define 
        addEffectTarget(t,s,a) = DestroyEffect(AddSpecialEffectTarget(s,t,a))
        addEffectTarget(t,s) = DestroyEffect(AddSpecialEffectTarget(s,t,"chest"))
        addEffectXY(x,y,s) = DestroyEffect(AddSpecialEffect(s,x,y))
    enddefine
    
    // Let's add some effects depending on path
    void addTerrainSfx(real x,real y){
        if(IsTerrainLand(x,y)){
            addEffectXY(x,y,"Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl")
        } else {
            addEffectXY(x,y,"Abilities\\Spells\\Other\\CrushingWave\\CrushingWaveDamage.mdl")
        }
    }

endlibrary