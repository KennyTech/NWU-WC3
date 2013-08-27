//******************************************************************************
//  muZk WayPoint "System"
//    version Release
    // Bottom:
        // KH: loc6->loc8->loc9
        // SH: loc6->loc4->loc2
    // Middle:
        // KH: ->loc9
        // SH: ->loc2
    // Top:
        // KH: ->loc5->loc7->loc9
        // SH: ->loc5->loc3->loc2
//******************************************************************************
library Waypoint initializer init requires TimerUtils{

    ////--------------------------------------- MOVEMENT ---------------------------------------

    // Returns next waypoint
    location GetNextWayPoint(unit u){
        return udg_WayPoints[GetUnitAbilityLevel(u,'A0GU')]
    }

    // Moves a unit to his next waypoint
    nothing SetNextWayPoint(unit u){
        call RemoveSavedHandle(HT,GetHandleId(u),105)
        call IssuePointOrderByIdLoc(u,851983,udg_WayPoints[GetUnitAbilityLevel(u,'A0GU')])
    }
    
    ////--------------------------------------- INITIALIZATION ---------------------------------------
    
    private nothing Init(){
        udg_MovePoint2 = GetRectCenter(gg_rct_Konoha_Village)
        udg_MovePoint4 = GetRectCenter(gg_rct_Path_Lower_Konoha)
        udg_MovePoint6 = GetRectCenter(gg_rct_Path_Lower_Middle)
        udg_MovePoint8 = GetRectCenter(gg_rct_Path_Lower_Shinobi)
        udg_MovePoint3 = GetRectCenter(gg_rct_Path_Upper_Konoha)
        udg_MovePoint5 = GetRectCenter(gg_rct_Path_Upper_Middle)
        udg_MovePoint7 = GetRectCenter(gg_rct_Path_Upper_Shinobi)
        udg_MovePoint9 = GetRectCenter(gg_rct_Shinobi_Village)
        udg_WayPoints[2] = udg_MovePoint2
        udg_WayPoints[4] = udg_MovePoint4
        udg_WayPoints[6] = udg_MovePoint6
        udg_WayPoints[8] = udg_MovePoint8
        udg_WayPoints[3] = udg_MovePoint3
        udg_WayPoints[5] = udg_MovePoint5
        udg_WayPoints[7] = udg_MovePoint7
        udg_WayPoints[9] = udg_MovePoint9
        ReleaseTimerEx()
    }
    
    // We don't need it to be started in the Map Initialization
    
    private nothing init(){
        TimerStart(NewTimer(),10,false,function Init)
    }
}