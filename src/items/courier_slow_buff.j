scope CourierSlowBuff initializer Init{

	define EMPTY_BOTTLE = 'I066'
	define SLOW_ABIL    = 'A0LF'
	define SLOW_BUFF    = 'B04H'

	private boolean manipulateItem(){

		item picked = GetManipulatedItem()
		unit courier = GetTriggerUnit()

		if(IsUnitCourier(courier) and GetItemTypeId(picked) == EMPTY_BOTTLE){
			int count = UnitCountItemsOfType(courier, EMPTY_BOTTLE)
			if(GetTriggerEventId() == EVENT_PLAYER_UNIT_DROP_ITEM){
				count--
			}
			if(count == 0){
				UnitRemoveAbility(courier, SLOW_ABIL)
				UnitRemoveAbility(courier, SLOW_BUFF)
			} else {
				UnitAddAbility(courier, SLOW_ABIL)
			}
		}

		picked = null
		courier = null
		return false
	}

	private void Init(){
		GT_RegisterPlayerEventAction(EVENT_PLAYER_UNIT_PICKUP_ITEM,function manipulateItem)
		GT_RegisterPlayerEventAction(EVENT_PLAYER_UNIT_DROP_ITEM,function manipulateItem)
	}

}