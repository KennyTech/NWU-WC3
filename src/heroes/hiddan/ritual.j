scope Ritual
	define private RITUAL_RAWCODE = 'sdsd';

	public bool onSpell()
	{
		return false;
	}

	public void Init()
	{
		GT_RegisterSpellEffectEvent(RITUAL_RAWCODE, function onSpell);
	}
endscope