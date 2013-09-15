scope Dash
	define private DASH_RAWCODE = 'a00s'; // change here
	define private DUMMY_ID = 'hfoo';
	define private ANIMATION = "spell 1";
	define private TIMEOUT = 0.03125;
	define private SPECIAL_EFFECT = "Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl";
	define private EFFECT_ATTACH = "chest";

	define private DASH_SLOW_RAWCODE = 'asho';
	define private DASH_SLOW_ORDER = "thunderclap";

	define private DASH_DAMAGE_RAWCODE = 'lefu';
	define private DASH_DAMAGE_ORDER = "thunderclap";

	define private saveCaster(timerId, caster) = SetHandleHandle(timerId, "Dash|caster", caster);
	define private saveSlowDummy(timerId, dummy) = SetHandleHandle(timerId, "Dash|dummy|slow", dummy);
	define private saveDamageDummy(timerId, dummy) = SetHandleHandle(timerId, "Dash|dummy|damage", dummy);
	define private saveSpellTargetX(timerId, x) = SetHandleReal(timerId, "Dash|target|x", x);
	define private saveSpellTargetY(timerId, y) = SetHandleReal(timerId, "Dash|target|y", y);

	define private getCaster(timerId) = GetHandleUnit(timerId, "Dash|caster");
	define private getSlowDummy(timerId) = GetHandleUnit(timerId, "Dash|dummy|slow");
	define private getDamageDummy(timerId) = GetHandleUnit(timerId, "Dash|dummy|damage");
	define private getSpellTargetX(timerId) = GetHandleReal(expiredTimerId, "Dash|target|x");
	define private getSpellTargetY(timerId) = GetHandleReal(expiredTimerId, "Dash|target|y");

	define private removeCaster(timerId) = RemoveHandle(timerId, "Dash|caster");
	define private removeSlowDummy(timerId) = RemoveHandle(timerId, "Dash|dummy|slow");
	define private removeDamageDummy(timerId) = RemoveHandle(timerId, "Dash|dummy|damage");
	define private removeSpellTargetX(timerId) = RemoveHandle(timerId, "Dash|target|x");
	define private removeSpellTargetY(timerId) = RemoveHandle(timerId, "Dash|target|y");

	private void periodic()
	{
		/*******************************
		 * Falta el detonador Dash Ani *
		 *******************************/

		timer expiredTimer = GetExpiredTimer();
		int expiredTimerId = GetHandleId(expiredTimer);

		unit caster = getCaster(expiredTimerId);
		unit slowDummy = getSlowDummy(expiredTimerId);
		unit damageDummy = getDamageDummy(expiredTimerId);

		real spellTargetX = getSpellTargetX(expiredTimerId);
		real spellTargetY = getSpellTargetY(expiredTimerId);

		real distanceBetweenCasterAndSpellTarget = DistanceBetweenCoords(GetUnitX(caster), GetUnitY(caster), spellTargetX, spellTargetY);

		SetUnitPosition(caster, /* nueva posicion xD */);

		SetUnitPosition(slowDummy, GetUnitX(caster), GetUnitY(caster));
		IssueImmediateOrder(slowDummy, DASH_SLOW_ORDER);

		if ( distanceBetweenCasterAndSpellTarget <= 100. )
		{
			DestroyEffect(AddSpecialEffectTarget(SPECIAL_EFFECT, caster, EFFECT_ATTACH));

			PauseUnit(triggerUnit, false);
			SetUnitPathing(triggerUnit, true);

			removeCaster(expiredTimerId);
			removeSlowDummy(expiredTimerId);
			removeDamageDummy(expiredTimerId);
			removeSpellTargetX(expiredTimerId);
			removeSpellTargetY(expiredTimerId);

			RemoveUnit(slowDummy);
			RemoveUnit(damageDummy);

			ReleaseTimer(expiredTimer);
		}
		elseif ( distanceBetweenCasterAndSpellTarget <= 400. )
		{
			if ( damageDummy != null )
			{
				IssueImmediateOrder(damageDummy, DASH_DAMAGE_ORDER);

				UnitApplyTimedLife(damageDummy, 'BTLF', 1.);
				removeDamageDummy(expiredTimerId);
			}
		}

		expiredTimer = null;
		caster = null;
		slowDummy = null;
		damageDummy = null;
	}

	public bool onSpell()
	{
		unit triggerUnit = GetTriggerUnit();

		real spellTargetX = GetSpellTargetX();
		real spellTargetY = GetSpellTargetY();

		player triggerPlayer = GetTriggerPlayer();

		unit slowDummy = CreateUnit(triggerPlayer, DUMMY_ID, GetUnitX(triggerUnit), GetUnitY(triggerUnit), 0.);
		unit damageDummy = CreateUnit(triggerPlayer, DUMMY_ID, spellTargetX, spellTargetY, 0.);

		int abilityLevel = GetUnitAbilityLevel(triggerUnit, DASH_RAWCODE);

		timer t = NewTimer();
		int timerId = GetHandleId(t);

		UnitAddAbility(slowDummy, DASH_SLOW_RAWCODE);
		SetUnitAbilityLevel(slowDummy, DASH_SLOW_RAWCODE, abilityLevel);

		UnitAddAbility(damageDummy, DASH_DAMAGE_RAWCODE);
		SetUnitAbilityLevel(damageDummy, DASH_DAMAGE_RAWCODE, abilityLevel);

		PauseUnit(triggerUnit, true);
		SetUnitPathing(triggerUnit, false);

		SetUnitAnimation(triggerUnit, ANIMATION);

		saveCaster(timerId, triggerUnit);

		saveSlowDummy(timerId, slowDummy);
		saveDamageDummy(timerId, damageDummy);

		saveSpellTargetX(timerId, spellTargetX);
		saveSpellTargetY(timerId, spellTargetY);

		TimerStart(t, TIMEOUT, true, function periodic);

		triggerUnit = null;
		triggerPlayer = null;
		slowDummy = null;
		damageDummy = null;
		t = null;

		return false;
	}

	public void Init()
	{
		GT_RegisterSpellEffectEvent(DASH_RAWCODE, function onSpell);
	}
endscope