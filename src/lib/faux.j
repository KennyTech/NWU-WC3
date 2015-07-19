library Faux

	globals
		private hashtable FAUX = InitHashtable()
	endglobals

 //----------------------------  
    // Faux Handle Vars
    function SetHandleHandle takes integer subject, string name, agent value returns nothing
      call SaveAgentHandle(FAUX,subject,StringHash(name),value)
    endfunction
    function SetHandleInt takes integer subject, string name, integer value returns nothing
      call SaveInteger(FAUX, subject, StringHash(name), value)
    endfunction
    function SetHandleBoolean takes integer subject, string name, boolean value returns nothing
      call SaveBoolean(FAUX, subject, StringHash(name), value)
    endfunction
    function SetHandleReal takes integer subject, string name, real value returns nothing
      call SaveReal(FAUX, subject, StringHash(name), value)
    endfunction
    function SetHandleString takes integer subject, string name, string value returns nothing
      call SaveStr(FAUX, subject, StringHash(name), value)
    endfunction
    function SetHandleLightning takes integer subject, string name, lightning value returns nothing
      call SaveLightningHandle(FAUX, subject, StringHash(name), value)
    endfunction
    function SetHandleDestructable takes integer subject, string name, destructable value returns nothing
      call SaveDestructableHandle(FAUX, subject, StringHash(name), value)
    endfunction    
    function SetHandleTA takes integer subject, string name, triggeraction value returns nothing
      call SaveTriggerActionHandle(FAUX, subject, StringHash(name), value)
    endfunction
    function SetHandleTextTag takes integer subject, string name, texttag value returns nothing
      call SaveTextTagHandle(FAUX, subject, StringHash(name), value)
    endfunction
    function GetHandleDestructable takes integer subject, string name returns destructable
      return LoadDestructableHandle(FAUX, subject, StringHash(name))
    endfunction
    function GetHandleInt takes integer subject, string name returns integer
      return LoadInteger(FAUX, subject, StringHash(name))
    endfunction
    function GetHandleBoolean takes integer subject, string name returns boolean
      return LoadBoolean(FAUX, subject, StringHash(name))
    endfunction
    function GetHandleReal takes integer subject, string name returns real
      return LoadReal(FAUX, subject, StringHash(name))
    endfunction
    function GetHandleString takes integer subject, string name returns string
      return LoadStr(FAUX, subject, StringHash(name))
    endfunction
    function GetHandleUnit takes integer subject, string name returns unit
      return LoadUnitHandle(FAUX, subject, StringHash(name))
    endfunction
    function GetHandleItem takes integer subject, string name returns item
      return LoadItemHandle(FAUX, subject, StringHash(name))
    endfunction
    function GetHandleTimer takes integer subject, string name returns timer
      return LoadTimerHandle(FAUX, subject, StringHash(name))
    endfunction
    function GetHandleTrigger takes integer subject, string name returns trigger
      return LoadTriggerHandle(FAUX, subject, StringHash(name))
    endfunction
    function GetHandleTA takes integer subject, string name returns triggeraction
      return LoadTriggerActionHandle(FAUX, subject, StringHash(name))
    endfunction
    function GetHandleEffect takes integer subject, string name returns effect
      return LoadEffectHandle(FAUX, subject, StringHash(name))
    endfunction
    function GetHandleGroup takes integer subject, string name returns group
      return LoadGroupHandle(FAUX, subject, StringHash(name))
    endfunction
    function GetHandleLightning takes integer subject, string name returns lightning
      return LoadLightningHandle(FAUX, subject, StringHash(name))
    endfunction
    function GetHandleWidget takes integer subject, string name returns widget
      return LoadWidgetHandle(FAUX, subject, StringHash(name))
    endfunction
    function GetHandleLocation takes integer subject, string name returns location
      return LoadLocationHandle(FAUX, subject, StringHash(name))
    endfunction
    function GetHandlePlayer takes integer subject, string name returns player
      return LoadPlayerHandle(FAUX, subject, StringHash(name))
    endfunction
    function GetHandleRegion takes integer subject, string name returns region
      return LoadRegionHandle(FAUX, subject, StringHash(name))
    endfunction
    function GetHandleRect takes integer subject, string name returns rect
      return LoadRectHandle(FAUX, subject, StringHash(name))
    endfunction
    function GetHandleForce takes integer subject, string name returns force
      return LoadForceHandle(FAUX, subject, StringHash(name))
    endfunction
    function GetHandleFogmodifier takes integer subject, string name returns fogmodifier
      return LoadFogModifierHandle(FAUX, subject, StringHash(name))
    endfunction
    function GetHandleTimerDialog takes integer subject, string name returns timerdialog
      return LoadTimerDialogHandle(FAUX, subject, StringHash(name))
    endfunction
    function GetHandleTextTag takes integer subject, string name returns texttag
      return LoadTextTagHandle(FAUX, subject, StringHash(name))
    endfunction
    function HaveHandleHandle takes integer subject, string name returns boolean
      return HaveSavedHandle(FAUX, subject, StringHash(name))
    endfunction
    function HaveHandleInt takes integer subject, string name returns boolean
      return HaveSavedInteger(FAUX, subject, StringHash(name))
    endfunction
    function HaveHandleReal takes integer subject, string name returns boolean
      return HaveSavedReal(FAUX, subject, StringHash(name))
    endfunction
    function HaveHandleString takes integer subject, string name returns boolean
      return HaveSavedString(FAUX, subject, StringHash(name))
    endfunction
    function HaveHandleBoolean takes integer subject, string name returns boolean
      return HaveSavedBoolean(FAUX, subject, StringHash(name))
    endfunction
    function RemoveHandle takes integer subject, string name returns nothing
      call SaveAgentHandle(FAUX,subject,StringHash(name), null)
      call RemoveSavedHandle(FAUX,subject,StringHash(name))
    endfunction
    function RemoveInt takes integer subject, string name returns nothing
      call SaveInteger(FAUX,subject,StringHash(name), 0)
      call RemoveSavedInteger(FAUX,subject,StringHash(name))
    endfunction
    function RemoveReal takes integer subject, string name returns nothing
      call SaveReal(FAUX,subject,StringHash(name), 0.0)
      call RemoveSavedReal(FAUX,subject,StringHash(name))
    endfunction
    function RemoveBoolean takes integer subject, string name returns nothing
      call SaveBoolean(FAUX,subject,StringHash(name), false)
      call RemoveSavedBoolean(FAUX,subject,StringHash(name))
    endfunction
    function RemoveStr takes integer subject, string name returns nothing
      call SaveStr(FAUX,subject,StringHash(name), null)
      call RemoveSavedString(FAUX,subject,StringHash(name))
    endfunction
    function FauxFlush takes integer subject returns nothing
    	call FlushChildHashtable(FAUX, subject)
    endfunction

endlibrary