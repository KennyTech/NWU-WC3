scope ChidoriLearn

    define private ID = 'A09J';

    private boolean onLearn(){
        unit Caster = GetTriggerUnit()

        UnitAddAbility(Caster, 'A05N' )
        SetUnitAbilityLevel(Caster, 'A05N', GetUnitAbilityLevel(Caster,'A09J') )
        UnitMakeAbilityPermanent(Caster,true,'A05N')

        return false
    }

    public void Init(){
        GT_LearnEvent(ID,function onLearn)
    }
endscope