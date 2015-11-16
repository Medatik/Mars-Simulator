!------------------------------------------------------------------------------
!
! MODULE: affichage
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
module Affichage
    use gnufor2
    implicit none
    real,parameter:: Ym=1
    contains
    subroutine show(d)
        real,dimension(10)::t
        character::o
        real,dimension(10)::d
        integer::i,ierror3
        open (unit=17, file="UV_vs_Sources_surface.txt", status="replace", action="write", iostat=ierror3)
        if (ierror3 /= 0) then
            print*, "Failed to open the file"
            stop
        end if
        do i=1,10
            t(i)=i
        enddo
        print*,""
        print*,"------------------------------------------------"
        print*,"|     Martian year    |      Fglyc - Fuv       |"
        do i=1,10
            if(d(i)<0) then
                d(i)=0
           endif
        !   print*,"------------------------------------------------"
        !    print*,"|",t(i),"        |   ",d(i),"   |"
            write(17,*) t(i),d(i)
        enddo
        !print*,"------------------------------------------------"
        print*,"Coupe transversale ? o/n"
        read(5,*) o
        if(o=="o") then
            call execute_command_line("gnuplot -persist gnuplot.gnu",exitstat=i)
        endif
        call execute_command_line("gnuplot -persist command.gnu",exitstat=i)
        !call execute_command_line("gnuplot -persist command.gnu",exitstat=i)
    end subroutine show
end module Affichage
