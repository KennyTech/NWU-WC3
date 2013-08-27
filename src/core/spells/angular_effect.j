library AngularEffect requires Spells
    //================================================================
        struct AngularEffect extends array
            implement Alloc
            
            unit u
            real va
            real vz
            real vxy
            real angle
            unit ball
            real time
            integer abil
        
            static method periodic takes nothing returns boolean
                local thistype this=KT_GetData()
                set this.time=this.time-KT_PERIOD
                if this.time>0 and GetWidgetLife(this.u)>0.405 and (abil==0 or GetUnitAbilityLevel(this.u,abil)>0) then
                    call FxVisiblity(this.u,this.ball)
                    set this.angle = this.angle + this.va
                    call SetUnitX(this.ball,GetUnitX(this.u)+this.vxy*Cos(this.angle))
                    call SetUnitY(this.ball,GetUnitY(this.u)+this.vxy*Sin(this.angle))
                    call SetUnitFlyHeight(this.ball,this.vz+this.vz*Sin(this.angle),0)
                    call SetUnitOwner(this.ball,GetOwningPlayer(this.u),false)
                    return false
                endif
                call KillUnit(this.ball)
                set this.ball=null
                set this.u=null
                return true
            endmethod
            static method create takes unit u,unit dummy,real va,real vxy,real vz,real time,integer abil returns thistype
                local thistype this=allocate()
                set this.u=u
                set this.va=va*bj_DEGTORAD
                set this.vxy=vxy
                set this.vz=vz
                set this.angle=GetRandomReal(0,2*bj_PI)
                set this.ball=dummy
                set this.time=time
                set this.abil=abil
                if abil>0 then
                    call AddAbility(u,abil)
                endif
                call KT_Add(function thistype.periodic,this,KT_PERIOD)
                return this
            endmethod

        endstruct
    //================================================================
endlibrary