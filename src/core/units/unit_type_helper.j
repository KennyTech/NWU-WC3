library UnitTypeHelper{

    boolean isKyuubi(unit u){
        return GetUnitTypeId(u) == 'n01J'
    }


    boolean isUnitAlive(unit u){
        return GetWidgetLife(u) > 0.405;
    }

    boolean isHero(unit u){
        return IsUnitType(u, UNIT_TYPE_HERO)
    }

    boolean isIllusion(unit u){
        return IsUnitIllusion(u)
    }
}