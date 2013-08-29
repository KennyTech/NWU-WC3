scope CreepsInit initializer Init    
    private void Init() {
        // Tipos de los distintos creeps
        //----------------------------------------
        // Konoha
            // Arriba
            set udg_CreepsSpawnData[1] = 'h00D' 
            set udg_CreepsSpawnData[2] = 'h00I' 
            // Medio
            set udg_CreepsSpawnData[3] = 'h00E'
            set udg_CreepsSpawnData[4] = 'h00U'
            // Abajo
            set udg_CreepsSpawnData[5] = 'h00G'
            set udg_CreepsSpawnData[6] = 'h00T'
        //----------------------------------------
        // Shinobi
            // Arriba
            set udg_CreepsSpawnData[7]  = 'h00D' 
            set udg_CreepsSpawnData[8]  = 'h00I' 
            // Medio
            set udg_CreepsSpawnData[9]  = 'h00E'
            set udg_CreepsSpawnData[10] = 'h00U'
            // Abajo
            set udg_CreepsSpawnData[11] = 'h00G'
            set udg_CreepsSpawnData[12] = 'h00T'
        //----------------------------------------
        // Actualizacion de los distintos creeps
            set udg_Creep_Actualizacion[1] = 'R006' // Arriba
            set udg_Creep_Actualizacion[2] = 'R003' // Medio
            set udg_Creep_Actualizacion[3] = 'R005' // Abajo
            BJDebugMsg("Funciona")
    }
endscope