scope Jashins
	define private JASHINS_RAWCODE = 'slmc';
	define private JASHINS_BLESSING_ARMOR_RAWCODE = 'slms';
	define private JASHINS_BLESSING_HP = 'smdd';

	private void onDamage(unit source, unit target, real damage)
	{
		real targetLife;
		real targetMaxLife;

		int abilityLevel;
		int nextLevel;

		if ( GetUnitAbilityLevel(target, JASHINS_RAWCODE) > 0 )
		{
			targetLife = GetWidgetLife(target);
			targetMaxLife = GetUnitState(target, UNIT_STATE_MAX_LIFE);

			abilityLevel = GetUnitAbilityLevel(target, JASHINS_RAWCODE);
			
			if ( targetLife <= targetMaxLife && targetLife > 0.75 * targetMaxLife ) 
			{
				nextLevel = abilityLevel;
			}
			elseif ( targetLife > 0.50 * targetMaxLife && targetLife <= 0.75 * targetMaxLife )
			{
				nextLevel = 4 + abilityLevel;
			}
			elseif ( targetLife <= 0.50 * targetMaxLife && targetLife > 0.25 * targetMaxLife )
			{
				nextLevel = 8 + abilityLevel;
			}
			elseif ( targetLife <= 0.25 * targetMaxLife )
			{
				nextLevel = 12 + abilityLevel;
			}

			SetUnitAbilityLevel(target, JASHINS_BLESSING_ARMOR_RAWCODE, nextLevel);
			SetUnitAbilityLevel(target, JASHINS_BLESSING_HP_RAWCODE, nextLevel);
		}
	}

	public bool onLearn()
	{
		unit triggerUnit = GetTriggerUnit();

		if ( GetUnitAbilityLevel(triggerUnit, JASHINS_RAWCODE) == 0 )
		{
			UnitAddAbility(triggerUnit, JASHINS_BLESSING_ARMOR_RAWCODE);
			UnitAddAbility(triggerUnit, JASHINS_BLESSING_HP);
		}

		triggerUnit = null;

		return false;
	}

	public void Init()
	{
		RegisterDamageResponse(onDamage);
		GT_LearnEvent(JASHINS_RAWCODE, function onLearn);
	}
endscope