library HTAPI{

    //*****************************************
    //  Keys
    //*****************************************  
    
    define{
        KEY_SEAL_OF_CHAKRA    = 200
        KEY_KANKURO_ULTI      = 119 // BOOLEAN
        KEY_BUG_SHIELD        = 101 // SFX AND HP
        KEY_INO_ULTIMATE      = 121 // SAVES A BOOLEAN AND A UNIT
        KEY_BUG_SHIELD_TIME   = 201 // TIME
        KEY_BUG_SHIELD_CASTER = 202
        KEY_HINATA_BLOCK      = 100
        KEY_BUG_SHIELD_TIMER  = 203
        KEY_BUG_SHIELD_DAMAGE = 204
    }

    define{
        IsMindControlled(u) = LoadBoolean(HT, GetHandleId(u), KEY_INO_ULTIMATE) == true
        GetMindController(u)  = LoadUnitHandle(HT, GetHandleId(u), KEY_INO_ULTIMATE) 
    }

    //*****************************************
    //  Attatch
    //*****************************************    
    define{
        SetReal(h,key,value)   = SaveReal(HT,h,key,value)
        SetInt(h,key,value)    = SaveInteger(HT,h,key,value)
        SetUnit(h,key,value)   = SaveAgentHandle(HT,h,key,value)
        SetGroup(h,key,value)  = SaveAgentHandle(HT,h,key,value)
        SetEffect(h,key,value) = SaveEffectHandle(HT,h,key,value)
        SetTimer(h,key,value)  = SaveAgentHandle(HT,h,key,value)
        
        GetReal(h,key)   = LoadReal(HT,h,key)
        GetInt(h,key)    = LoadInteger(HT,h,key)
        GetUnit(h,key)   = LoadUnitHandle(HT,h,key)
        GetGroup(h,key)  = LoadGroupHandle(HT,h,key)
        GetEffect(h,key) = LoadEffectHandle(HT,h,key)
        GetTimer(h,key)  = LoadTimerHandle(HT,h,key)
    }
    
    define{
        setReal(h,key,value)   = SaveReal(HT,h,key,value)
        setInt(h,key,value)    = SaveInteger(HT,h,key,value)
        setUnit(h,key,value)   = SaveAgentHandle(HT,h,key,value)
        setGroup(h,key,value)  = SaveAgentHandle(HT,h,key,value)
        setEffect(h,key,value) = SaveEffectHandle(HT,h,key,value)
        setPlayer(h,key,value) = SaveAgentHandle(HT,h,key,value)
        
        getReal(h,key)   = LoadReal(HT,h,key)
        getInt(h,key)    = LoadInteger(HT,h,key)
        getUnit(h,key)   = LoadUnitHandle(HT,h,key)
        getGroup(h,key)  = LoadGroupHandle(HT,h,key)
        getEffect(h,key) = LoadEffectHandle(HT,h,key)
        getPlayer(h,key) = LoadPlayerHandle(HT,h,key)
        getTimer(h,key)  = LoadTimerHandle(HT,h,key)
    }
    
    integer GetIntDec(integer h,integer key) {
        integer value=GetInt(h,key)-1
        SetInt(h,key,value)
        return value
    }
    
    integer GetIntInc(integer h,integer key) {
        integer value=GetInt(h,key)+1
        SetInt(h,key,value)
        return value
    }
    
}