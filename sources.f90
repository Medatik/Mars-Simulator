!Sources en molécules organiques => on suppose qu'une molécules se résume à un PAH
!------------------------------------------------------------------------------
!
! MODULE: Sources
!
!> @author
!> LAHIYANE Atik
!
! DESCRIPTION:
!> Lire le contenu des fichiers sources et les stocker dans des tableaux dans le programme
!
! REVISION HISTORY:
! DD Mmm YYYY - Initial Version
! TODO_dd_mmm_yyyy - TODO_describe_appropriate_changes - TODO_name
!-----------------------------------------------------------------------------
module Sources
    implicit none
    real,parameter:: Fmic_met=7.08
    real,parameter:: glycine=0.25
    real::Fgly
    real::pah
    real,parameter:: density=2
    contains
    !----------------------------------- Terme général du flux des molécules
    subroutine show_values
        print*,""
        print*, "Micrometeorite flux range in the surface:"
        print*,""
        print*,"",Fmic_met,"molecules/(km².yrm)"
        print*,"","   with a density of",density,"g/cm³"
        print*,""
    end subroutine show_values
    !--------------------------------------------------
    !!Initialise les constantes de sources en des valeurs correspondant au Glycine
    subroutine gly
        Fgly=glycine*Fmic_met/10**6
        print*,""
        print*,"--> [Glycine]micrometeorites = (",glycine,") ppm"
        print*,"--> Funa_Glycine_Mars =",Fgly,"g/(km².yr)"
        Fgly=Fgly*8.021e21*1.881
        print*,""
        print*,"Conversion to a number of molecules and to martian year:"
        print*,""
        print*,"Funa_Glycine_Mars =",Fgly,"molecules/(km².yrm)"
        print*,
        print*,""
    end subroutine gly
    !--------------------------------------------------
    !Initialise les constantes de sources en des valeurs correspondant au PAH
    subroutine pa
        pah=0.708
        print*,""
        print*,"10% of the flux was considered as an upper value for PAH :"
        print*,""
        print*,"--> F_unaltered_PAH_Mars =",pah,"g/(km².yr)"
        print*,""
        print*,"Conversion to number of molecules and martian year:"
        print*,""
        pah=pah*2.98e20*1.881
        print*,"Funa_PAH_Mars =",pah,"molecules/(km².yrm)"
        print*,""
    end subroutine pa
    !=============================
    !Routine qui modifie les valeurs constantes suivant le noms du composant chimique
    subroutine research(s)
        character(len=20)::s
        if(s=="glycine" .or. s=="Glycine") then
            call gly
        elseif(s=="PAH" .or. s=="Pah" .or. s=="pah") then
            call pa
        end if
    end subroutine
    !==============================
end module Sources
