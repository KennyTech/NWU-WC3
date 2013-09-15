scope Sadism
	define private SADISM_RAWCODE = 'assm';
	define private SADISM_DAMAGE_RAWCODE = 'take';
	define private SADISM_AS_RAWCODE = 'smlf'; // wtf is "as"?

	define private SADISM_AS_ORDER = "unholyfrenzy";

	define private DUMMY_ID = 'hfoo';

	define private SPECIAL_EFFECT = "Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl";
	define private EFFECT_ATTACH = "chest";

	private void finish()
	{
		unit caster = GetTimerUnit();
		UnitRemoveAbility(caster, SADISM_DAMAGE_RAWCODE);

		ReleaseTimerEx();

		caster = null;
	}

	private void onTimeOut()
	{
		unit caster = GetTimerUnit();
		unit dummy = CreateUnit(GetOwningPlayer(caster), DUMMY_ID, GetUnitX(caster), GetUnitY(caster), 0);

		int abilityLevel = GetUnitAbilityLevel(caster, SADISM_RAWCODE);

		IssueImmediateOrder(caster, "stop");

		UnitApplyTimedLife(dummy, 'BTLF', 1.);

		UnitAddAbility(caster, SADISM_DAMAGE_RAWCODE);
		UnitAddAbility(dummy, SADISM_AS_RAWCODE);

		SetUnitAbilityLevel(caster, SADISM_DAMAGE_RAWCODE, abilityLevel);
		SetUnitAbilityLevel(dummy, SADISM_AS_RAWCODE, abilityLevel);

		UnitDamageTargetEx(caster, caster, (0.04 + abilityLevel*2 - 0.01) * GetUnitState(caster, UNIT_STATE_MAX_LIFE), true, false, ATTACK_TYPE_CHAOS, DAMAGE_TYPE_UNIVERSAL, null);
		IssueTargetOrder(dummy, SADISM_AS_ORDER, caster);

		TimerStart(GetExpiredTimer(), 5., false, function finish);

		caster = null;
		dummy = null;
	}

	public bool onSpell()
	{
		unit triggerUnit = GetTriggerUnit();

		DestroyEffect(AddSpecialEffectTarget(SPECIAL_EFFECT, triggerUnit, EFFECT_ATTACH));

		TimerStart(NewTimerUnit(triggerUnit), 0.25, false, function onTimeOut);

		triggerUnit = null;
		
		return false;
	}

	public void Init()
	{
		GT_RegisterSpellEffectEvent(DASH_RAWCODE, function onSpell);
	}
endscope