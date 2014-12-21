library StatusTimed requires Status

    private nothing onExpire(){
        timer t=GetExpiredTimer()
        integer h=GetHandleId(t)
        Status_Remove(GetUnit(h,0),GetInt(h,0))
        static if TEST_MODE then
            if GetInt(h,0) == STATUS_STUN then
                call BJDebugMsg("[Status_AddTimed] STATUS_STUN - REMOVING ")
            endif
        endif
        ReleaseTimer(t)
        t=null
    }

    nothing Status_AddTimed(unit u,integer status,real time){
        timer t=NewTimer()
        integer h=GetHandleId(t)
        Status_Add(u,status)
        SetUnit(h,0,u)
        SetInt(h,0,status)
        TimerStart(t,time,false,function onExpire)
        static if TEST_MODE then
            if status == STATUS_STUN then
                call BJDebugMsg("[Status_AddTimed] STATUS_STUN - TIME: " + R2S(time))
            endif
        endif
    }
    
    // WRAPPERS
    
    define {
        AddStunTimed(u,t) = Status_AddTimed(u,STATUS_STUN,t)
        AddDisarm(u,t) = Status_AddTimed(u,STATUS_DISARM_BOTH,t)
        IsUnitInvulnerable(u) = Status_Has(u,STATUS_INVULNERABLE)
        UnitAddInvulnerableTimed(u,t) = Status_AddTimed(u,STATUS_INVULNERABLE,t)
        UnitAddInvulnerable(u) = Status_Add(u,STATUS_INVULNERABLE)
        UnitRemoveInvulnerable(u) = Status_Remove(u,STATUS_INVULNERABLE)
        AddSilence(u,t) = Status_AddTimed(u,STATUS_SILENCE,t)
        IsSilenced(u) = Status_Has(u,STATUS_SILENCE)
    }

endlibrary