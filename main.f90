!------------------------------------------------------------------------------
! Programme de modélisation de l'abandance des molécules organiques sur Mars
!------------------------------------------------------------------------------
!
! MODULE: Main program
!
!> @author
!> LAHIYANE Atik
!
! DESCRIPTION:
!> This main program call the subroutine "run" of the module Controller
!
! REVISION HISTORY:
! DD Mmm YYYY - Initial Version
! TODO_dd_mmm_yyyy - TODO_describe_appropriate_changes - TODO_name
!------------------------------------------------------------------------------
program main
    use Controlleur
    implicit none
    integer::erro
    call run
end program main
