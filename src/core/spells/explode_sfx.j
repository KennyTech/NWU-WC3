// Terrain-sensitive SFX Explosion (Grass, Dirt, Water)

library ExplodeSFX

    function ExplodeSFX takes real x, real y returns nothing

        if GetTerrainType(x,y) == 1097101940 or GetTerrainType(x,y) == 1097101924 and GetTerrainCliffLevel(x,y) != 2 then // Dirt-type terrain and not in water
            call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Other\\Volcano\\VolcanoDeath.mdl",x,y)) // create dirt SFX
        elseif GetTerrainCliffLevel(x,y) == 2 then
            call DestroyEffect(AddSpecialEffect("Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl",x,y)) // create water SFX
        else
            call DestroyEffect(AddSpecialEffect("Objects\\Spawnmodels\\NightElf\\EntBirthTarget\\EntBirthTarget.mdl",x,y)) // create grass SFX
        endif
        
    endfunction

endlibrary