library OrderCreep

    function OrderCreep takes unit u returns nothing
        call IssuePointOrderByIdLoc(u,851983,udg_WayPoints[GetUnitAbilityLevel(u,'A0GU')])
    endfunction

endlibrary