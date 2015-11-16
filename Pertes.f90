!------------------------------------------------------------------------------
!
! MODULE: Pertes
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
module PertesUV
    implicit none
    !Flux at Mars surface (photons between 200 and 250 nm)!
    real:: Fmars
    real::Glycine_destroyed_per_photon
    real:: Gdest
    contains
    subroutine showUV
        print*, "Flux at mars surface considering photons between 200 and 250 nm :"
        print*,""
        print*,Fmars,"photons/(km².yrm)"
        print*,""
        print*,""
        print*,"The number of Glycine destroyed per incident photon ranges :"
        print*,""
        print*,Glycine_destroyed_per_photon,"molecule/photon"
        print*,""
        print*,""
        print*,"An estimate of the destruction of Glycine molecules by UV :"
        print*,""
        call showUVdestroyed
    end subroutine showUV
    !--------------------------
    subroutine showUVdestroyed
        print*,"Molecules destroyed by UV",Gdest,"molecules/(km².yrm)"
    end subroutine showUVdestroyed
    !--------------------------
    subroutine conversion_b(destroyed)
        real::destroyed
        Glycine_destroyed_per_photon=destroyed
        Gdest=Fmars*Glycine_destroyed_per_photon
    end subroutine conversion_b
    !-----------------------------

end module PertesUV
