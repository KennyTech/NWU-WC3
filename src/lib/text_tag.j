library TextTag

globals    
    // for custom centered texttags
    private constant real MEAN_CHAR_WIDTH = 5.5
    private constant real MAX_TEXT_SHIFT = 200.0
    private constant real DEFAULT_HEIGHT = 16.0

    // for default texttags
    private constant real   SIGN_SHIFT = 16.0
    private constant real   FONT_SIZE = 0.024
    private constant string MISS = "miss"
    
endglobals

/*function TextTag_ShowDamage takes unit u,unit source,real d,boolean pure returns nothing
    local texttag t=CreateTextTag()
    local real v=0.0355//TextTagSpeed2Velocity(64)
    local real a=GetRandomReal(0,bj_PI*2)
    local string text=I2S(R2I(RAbsBJ(d)))
    local player p=GetLocalPlayer()
    local integer index=GetPlayerId(p)
    if pure then
        call SetTextTagColor(t,0,255,255,255)
    elseif d<0 then
        call SetTextTagColor(t,0,125,255,255)
    elseif d>0 then
        call SetTextTagColor(t,0,255,125,255)
    else
        set a = 1.570795
        call SetTextTagColor(t,125,125,125,255)
    endif
    call SetTextTagText(t,text,0.023) // TextTagSize2Height(10)
    call SetTextTagPosUnit(t,u,0.0)
    call SetTextTagVelocity(t,v*Cos(a),v*Sin(a))
    call SetTextTagFadepoint(t,1.0)
    call SetTextTagPermanent(t,false)
    call SetTextTagLifespan(t,3.0)
    call SetTextTagVisibility(t,IsUnitVisible(u,p) and (damageshowall[index] or (damageshowhero[index] and IsUnitType(source,UNIT_TYPE_HERO)) or (damageshowplayer[index] and (GetOwningPlayer(u)==p or GetOwningPlayer(source)==p) )))
    set t = null
endfunction*/
/*
public function UnitBlockDamage takes unit u,real d returns nothing
    local texttag t = CreateTextTag()
    local real v = TextTagSpeed2Velocity(64)
    local real a = 1.570795
    call SetTextTagColor(t,125,125,125,255)
    call SetTextTagText(t,"Block "+I2S(R2I(d)),TextTagSize2Height(10))
    call SetTextTagPosUnit(t,u,0.0)
    call SetTextTagVelocity(t,v*Cos(a),v*Sin(a))
    call SetTextTagFadepoint(t,1.0)
    call SetTextTagPermanent(t,false)
    call SetTextTagLifespan(t,3.0)
    set t = null
    set u = null
endfunction
*/

//===========================================================================
//   Custom centered texttag on (x,y) position
//   color is in default wc3 format, for example "|cFFFFCC00"
//===========================================================================
public function XY takes real x, real y, string text, string color returns nothing
    local texttag tt = CreateTextTag()
    local real shift = RMinBJ(StringLength(text)*MEAN_CHAR_WIDTH, MAX_TEXT_SHIFT)
    call SetTextTagText(tt, color+text, FONT_SIZE)
    call SetTextTagPos(tt, x-shift, y, DEFAULT_HEIGHT)
    call SetTextTagVelocity(tt, 0.0, 0.04)
    call SetTextTagVisibility(tt, true)
    call SetTextTagFadepoint(tt, 2.5)
    call SetTextTagLifespan(tt, 4.0)
    call SetTextTagPermanent(tt, false)
    set tt = null
endfunction

//===========================================================================
//   Custom centered texttag above unit
//===========================================================================
public function Unit takes unit whichUnit, string text, string color returns nothing
    local texttag tt = CreateTextTag()
    local real shift = RMinBJ(StringLength(text)*MEAN_CHAR_WIDTH, MAX_TEXT_SHIFT)
    call SetTextTagText(tt, color+text, FONT_SIZE)
    call SetTextTagPos(tt, GetUnitX(whichUnit)-shift, GetUnitY(whichUnit), DEFAULT_HEIGHT)
    call SetTextTagVelocity(tt, 0.0, 0.04)
    call SetTextTagVisibility(tt, true)
    call SetTextTagFadepoint(tt, 2.5)
    call SetTextTagLifespan(tt, 4.0)
    call SetTextTagPermanent(tt, false)    
    set tt = null
endfunction

//===========================================================================
//   Custom centered texttag above unit
//===========================================================================
public function UnitOnly takes unit whichUnit, string text, string color returns nothing
    local texttag tt = CreateTextTag()
    local real shift = RMinBJ(StringLength(text)*MEAN_CHAR_WIDTH, MAX_TEXT_SHIFT)
    call SetTextTagText(tt, color+text, FONT_SIZE)
    call SetTextTagPos(tt, GetUnitX(whichUnit)-shift, GetUnitY(whichUnit), DEFAULT_HEIGHT)
    call SetTextTagVelocity(tt, 0.0, 0.04)
    call SetTextTagVisibility(tt, GetLocalPlayer()==GetOwningPlayer(whichUnit))
    call SetTextTagFadepoint(tt, 2.5)
    call SetTextTagLifespan(tt, 4.0)
    call SetTextTagPermanent(tt, false)    
    set tt = null
endfunction

//===========================================================================
//  Standard wc3 gold bounty texttag, displayed only to killing player 
//===========================================================================
public function GoldBounty takes unit whichUnit, integer bounty, player killer returns nothing
    local texttag tt = CreateTextTag()
    local string text = "+" + I2S(bounty)
    local real x = GetUnitX(whichUnit)
    local real y = GetUnitY(whichUnit)
    call SetTextTagText(tt, text, FONT_SIZE)
    call SetTextTagPos(tt, x-SIGN_SHIFT, y, 0.0)
    call SetTextTagColor(tt, 255, 220, 0, 255)
    call SetTextTagVelocity(tt, 0.0, 0.03)
    call SetTextTagVisibility(tt, GetLocalPlayer()==killer and IsUnitVisible(whichUnit,GetLocalPlayer()))
    call SetTextTagFadepoint(tt, 2.0)
    call SetTextTagLifespan(tt, 3.0)
    call SetTextTagPermanent(tt, false)
    call DestroyEffect(AddSpecialEffect("UI\\Feedback\\GoldCredit\\GoldCredit.mdl", x, y))
    set text = null
    set tt = null
endfunction

function ManaBurnEx takes unit whichUnit, integer dmg,boolean sfx returns nothing
    local texttag tt = CreateTextTag()
    local string text = "-" + I2S(dmg)
    call SetTextTagText(tt, text, FONT_SIZE)
    call SetTextTagPos(tt, GetUnitX(whichUnit)-SIGN_SHIFT, GetUnitY(whichUnit), 0.0)
    call SetTextTagColor(tt, 82, 82 ,255 ,255)
    call SetTextTagVelocity(tt, 0.0, 0.04)
    call SetTextTagVisibility(tt, true)
    call SetTextTagFadepoint(tt, 2.0)
    call SetTextTagLifespan(tt, 5.0)
    call SetTextTagPermanent(tt, false)
    if sfx then
        call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Charm\\CharmTarget.mdl",whichUnit,"chest"))
    endif
    set text = null
    set tt = null
endfunction

define ManaBurn(u,d) = ManaBurnEx(u,d,true)
define ManaBurn(u,d,b) = ManaBurnEx(u,d,b)

//==============================================================================
/*
public function LumberBounty takes unit whichUnit, integer bounty, player killer returns nothing
    local texttag tt = CreateTextTag()
    local string text = "+" + I2S(bounty)
    call SetTextTagText(tt, text, FONT_SIZE)
    call SetTextTagPos(tt, GetUnitX(whichUnit)-SIGN_SHIFT, GetUnitY(whichUnit), 0.0)
    call SetTextTagColor(tt, 0, 200, 80, 255)
    call SetTextTagVelocity(tt, 0.0, 0.03)
    call SetTextTagVisibility(tt, GetLocalPlayer()==killer)
    call SetTextTagFadepoint(tt, 2.0)
    call SetTextTagLifespan(tt, 3.0)
    call SetTextTagPermanent(tt, false)
    set text = null
    set tt = null
endfunction

//===========================================================================
public function ManaBurn takes unit whichUnit, integer dmg returns nothing
    local texttag tt = CreateTextTag()
    local string text = "-" + I2S(dmg)
    call SetTextTagText(tt, text, FONT_SIZE)
    call SetTextTagPos(tt, GetUnitX(whichUnit)-SIGN_SHIFT, GetUnitY(whichUnit), 0.0)
    call SetTextTagColor(tt, 82, 82 ,255 ,255)
    call SetTextTagVelocity(tt, 0.0, 0.04)
    call SetTextTagVisibility(tt, true)
    call SetTextTagFadepoint(tt, 2.0)
    call SetTextTagLifespan(tt, 5.0)
    call SetTextTagPermanent(tt, false)    
    set text = null
    set tt = null
endfunction

//===========================================================================
public function Miss takes unit whichUnit returns nothing
    local texttag tt = CreateTextTag()
    call SetTextTagText(tt, MISS, FONT_SIZE)
    call SetTextTagPos(tt, GetUnitX(whichUnit), GetUnitY(whichUnit), 0.0)
    call SetTextTagColor(tt, 255, 0, 0, 255)
    call SetTextTagVelocity(tt, 0.0, 0.03)
    call SetTextTagVisibility(tt, true)
    call SetTextTagFadepoint(tt, 1.0)
    call SetTextTagLifespan(tt, 3.0)
    call SetTextTagPermanent(tt, false)
    set tt = null
endfunction
*/
//===========================================================================
public function CriticalStrike takes unit whichUnit, integer dmg returns nothing
    local texttag tt = CreateTextTag()
    local string text = I2S(dmg) + "!"
    call SetTextTagText(tt, text, FONT_SIZE)
    call SetTextTagPos(tt, GetUnitX(whichUnit), GetUnitY(whichUnit), 0.0)
    call SetTextTagColor(tt, 255, 0, 0, 255)
    call SetTextTagVelocity(tt, 0.0, 0.04)
    call SetTextTagVisibility(tt, GetLocalPlayer()==GetOwningPlayer(whichUnit))
    call SetTextTagFadepoint(tt, 2.0)
    call SetTextTagLifespan(tt, 5.0)
    call SetTextTagPermanent(tt, false)
    set text = null
    set tt = null    
endfunction

//===========================================================================
/*
public function ShadowStrike takes unit whichUnit, integer dmg, boolean initialDamage returns nothing
    local texttag tt = CreateTextTag()
    local string text = I2S(dmg)
    if initialDamage then
        set text = text + "!"
    endif
    call SetTextTagText(tt, text, FONT_SIZE)
    call SetTextTagPos(tt, GetUnitX(whichUnit), GetUnitY(whichUnit), 0.0)
    call SetTextTagColor(tt, 160, 255, 0, 255)
    call SetTextTagVelocity(tt, 0.0, 0.04)
    call SetTextTagVisibility(tt, true)
    call SetTextTagFadepoint(tt, 2.0)
    call SetTextTagLifespan(tt, 5.0)
    call SetTextTagPermanent(tt, false)    
    set text = null
    set tt = null
endfunction
*/

endlibrary