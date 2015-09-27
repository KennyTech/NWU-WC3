globals // Karin uses var arrays because many spells intertwine and global hashtables within scope isn't enough.
    integer array KF_level // For MPI (Multi Player Instanceability - 1 per player) - Kongou Fuusou Level
    unit array KF_Karin // For MPI - Kongou Fuusou Karin
    group array KarinChainGroup // For MPI
    unit array LF_Karin // For MPI - multiple Karin's channel "Life Force"
    timer array LF_Karin_Timer // For MPI - multiple Karin's channel "Life Force"
    group array KarinIDGroup // For MPI - multiple Karin's cast "Identify"
    unit array Karin // For MPI - multiple Karin's cast "Identify"
    unit KarinEE // For Easter Egg Karin effect and also for Mind's Eye Passive effect
endglobals
