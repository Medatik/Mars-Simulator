!------------------------------------------------------------------------------
!
! MODULE: ReadFromFile
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
!------------------------------------------------------------------------------
module readFromFile
    integer,dimension(200)::landa
    real,dimension(200)::tab
    integer::ierror,ierror1
    integer :: i
    integer::indicateur
    integer,dimension(34)::latitude
    real,dimension(200,34)::MarsUV
    contains
    !---------------------------------------------------------------------------
    !> @author
    !> LAHIYANE Atik
    !
    ! DESCRIPTION:
    !> Récupére les valeurs du flux UV à partir du fichier de Patel
    ! REVISION HISTORY:
    ! TODO_dd_mmm_yyyy - TODO_describe_appropriate_changes - TODO_name
    !
    !---------------------------------------------------------------------------
    subroutine FileToArray
        implicit none
        if(indicateur==0) then
            open (unit=14, file="Patel_Data_UV.txt", status="old", action="read", iostat=ierror)
            if (ierror /= 0) then
                print*, "Failed to open the file"
                stop
            end if
            do i=1,200
                read(14,*) landa(i),MarsUV(i,:)
                MarsUV(i,:)=MarsUV(i,:)*(i+200)/(3e8*(1.05e-34)*59354965)
            enddo
            close(14)
            indicateur=1
        endif
        print*,"processing ..."
    end subroutine FileToArray
    !---------------------------------------------------------------------------
    !> @author
    !> LAHIYANE Atik
    !
    ! DESCRIPTION:
    !> Utilise le paramètre 'lat_titude' et extrait du fichier chargé par FileToarray la colonne des valeur
    !>  du flux UV correspondante à la latitude choisie
    ! REVISION HISTORY:
    ! TODO_dd_mmm_yyyy - TODO_describe_appropriate_changes - TODO_name
    !
    !---------------------------------------------------------------------------
subroutine extraire_colonne(lat_titude)
    integer::lat_titude,ind
    ind=hash(lat_titude)
    do i=1,200
        tab(i)=MarsUV(i,ind)
    enddo
end subroutine extraire_colonne
!---------------------------------------------------------------------------
    !> @author
    !> LAHIYANE Atik
    !
    ! DESCRIPTION:
    !> !Fonction qui récupére une latitude et renvoie l'indice de la colonne de valeurs (dans le fichier de Patel)
    !   qui correspont à cette latitude
    ! REVISION HISTORY:
    ! TODO_dd_mmm_yyyy - TODO_describe_appropriate_changes - TODO_name
    !
    !---------------------------------------------------------------------------

    function hash(la_titude)
        integer::la_titude,hash
        hash=0
        latitude(1)=85
        do i=2,34
            latitude(i)=latitude(i-1)-5
        enddo
        do i=1,34
            if(latitude(i)==la_titude) then
                hash=i
            endif
        enddo
    end function hash
    !====================================
    function str(k)
        Integer k
        Character(len=2)::str
        Write( str, '(i2.2)' ) k
    end function str
    !====================================
    subroutine creer_fichier(nom,fd)
        character(len=*)::nom
        integer::ierror,fd
        do while(fd==100 .or. fd==101 .or. fd==102)
            fd=fd+1
        enddo
        open (unit=fd, file=nom, status="replace", action="write", iostat=ierror)
        if (ierror /= 0) then
            print*, "Failed to open the file"": Maybe the descriptor is already taken"
            stop
        end if
    end subroutine creer_fichier
    subroutine creer_fichiers(nom,nombre)
        integer::nombre
        character(len=*)::nom
        do i=0,nombre
            call creer_fichier(nom//"_"//str(i)//".dat",i+15)
        enddo
    end subroutine creer_fichiers
    !======================================================
    subroutine interactGnu(n)
        integer::n,i,ierror2
        character(len=2)::st
         open (unit=14, file="gnuplot.gnu" , status="replace", action="write", iostat=ierror2)
        if (ierror2 /= 0) then
            print*, "Failed to open the file"": Maybe the descriptor is already taken"
            stop
        end if
    write(14,*) "set title 'Présence des molécules en fonction de la profondeur' "
    write(14,*)"set tics scale 0.5"
    write(14,*)"set cbrange [1e16:2.0005e16]"
    write(14,*)"set terminal pngcairo size 800,400 enhanced font 'Verdana,10'"
    write(14,*)"set xrange[*:*]"
    write(14,*)"set yrange[1000:0]"
    write(14,*)"unset xtics"
    write(14,*)"set cblabel 'molecules/(km².yrm)' "
    write(14,*)"set pm3d; set palette"
    write(14,*)"set palette gamma 1.0"
    write(14,*)"set ylabel 'depth(µm)' "
    do i=1,n
        st=str(i)
        write(14,*) "plot 'dim_"//st//".dat' u 2:1:3 w image notitle"
        write(14,*) "set output './"//st//".png'"
    enddo
    write(14,*)"exit"
    close(14)
    end subroutine interactGnu
end module readFromFile
