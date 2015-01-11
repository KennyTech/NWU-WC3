library UnitTypeHelper{

    boolean isKyuubi(unit u){
        return GetUnitTypeId(u) == 'n01J'
    }

    boolean IsCircleOfPower(unit u){
        return GetUnitTypeId(u) == 'n01K'
    }

    boolean DoesUnitExist(unit u){
        return GetUnitTypeId(u) != 0
    }

    boolean IsUnitDead(unit u){
        return IsUnitType(u, UNIT_TYPE_DEAD) or not DoesUnitExist(u)
    }

    boolean isUnitAlive(unit u){
        return not IsUnitDead(u)
    }

    boolean isHero(unit u){
        return IsUnitType(u, UNIT_TYPE_HERO)
    }

    boolean isIllusion(unit u){
        return IsUnitIllusion(u)
    }
}