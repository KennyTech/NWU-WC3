library Maths{

	function ABU takes unit u1,unit u2 returns real
	    return Atan2(GetUnitY(u2)-GetUnitY(u1),GetUnitX(u2)-GetUnitX(u1))
	endfunction

	function ABP takes real x1,real y1,real x2,real y2 returns real
	    return Atan2(y2-y1,x2-x1)
	endfunction

	function DBU takes unit u1,unit u2 returns real
	    local real x=GetUnitX(u2)-GetUnitX(u1)
	    local real y=GetUnitY(u2)-GetUnitY(u1)
	    return SquareRoot(x*x+y*y)
	endfunction

	function DBP takes real x1,real y1,real x2,real y2 returns real
	    local real x=x1-x2
	    local real y=y1-y2
	    return SquareRoot(x*x+y*y)
	endfunction

	function ABS takes real r returns real
	    if r<0 then
	        return -r
	    endif
	    return r
	endfunction

	function DistanceBetweenCoords takes real X1, real Y1, real X2, real Y2 returns real
	    set X1 = X1 - X2
	    set Y1 = Y1 - Y2
	    return SquareRoot(X1*X1 + Y1*Y1)
	endfunction
	
}