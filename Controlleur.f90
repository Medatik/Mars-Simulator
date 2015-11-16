!------------------------------------------------------------------------------
!
! MODULE: Controller
!
!> @author
!> LAHIYANE Atik
!
! DESCRIPTION:
!> Ce module contient toutes les méthodes qui font les traitements des données
!
! REVISION HISTORY:
! DD Mmm YYYY - Initial Version
! TODO_dd_mmm_yyyy - TODO_describe_appropriate_changes - TODO_name
!------------------------------------------------------------------------------
module Controlleur
    use PertesUV
    use Sources
    use Affichage
    use readFromFile
    implicit none
    real::flux
    real::flux2
    contains
    !---------------------------------------------------------------------------
    !> @author
    !> LAHIYANE Atik
    !
    ! DESCRIPTION:
    !> Fait le bilan (sources-pertes) en prenant comme paramètre d'entrée le nom
    !> de la molécule choisi par l'utilisateur
    ! REVISION HISTORY:
    ! TODO_dd_mmm_yyyy - TODO_describe_appropriate_changes - TODO_name
    !
    !> @param[in] name
    !---------------------------------------------------------------------------
    subroutine bilan(name)
        implicit none
        real::Fm,Fuv
        integer::ans
        character(len=*)::name
        real,dimension(10)::resu
        integer::i
        real::diff
        if(name=="glycine") then
            Fm=Fgly
        endif
        if(name=="pah") then
            Fm=pah
        endif
        call ajout_pertes(name)
        Fuv=Gdest
        diff=Fm-Fuv
        resu(1)=diff
        do i=2,10
                resu(i)=resu(i-1)+diff
        enddo
        print*,"Entrée la durée de simulation en année :"
        read(5,*) ans
        call diminution_general(2e18,Fuv,ans)
        call show(resu)
        call calcul_tout
        call execute_command_line("gnuplot -persist vue_mars.gnu",exitstat=i)
    end subroutine bilan
    !---------------------------------------------------------------------------
    !> @author
    !> LAHIYANE Atik
    !
    ! DESCRIPTION:
    !> Demande à l'utilisateur d'entrée une latitude, un intervalle de longeur d'ondes
    !> et le coefficient de destruction de glycine par photon incident et renvoie l'integrale du flux uv
    !> correspondant
    ! REVISION HISTORY:
    ! TODO_dd_mmm_yyyy - TODO_describe_appropriate_changes - TODO_name
    !
    !> @param[in] name
    !> @param[out] Fm : flux UV
    !---------------------------------------------------------------------------
    subroutine ajout_pertes(name)
        implicit none
        character(len=*)::name
        integer::lat
        real,dimension(2)::lam
        print*,"Please enter a latitude value :"
        read(5,*) lat
        print*,"Please enter a range of wavelength :"
        read(5,*) lam
        print*,""
        print*,"Integrating UV flux between",lam(1),lam(2)
        Fmars=uv_integrale(lat,lam)
        print*,"Result :",Fmars
        print*,""
        if(name=="glycine") then
            print*,"Give a range of glycine destroyed per photon incident :"
            read(5,*) Glycine_destroyed_per_photon
            call conversion_b(Glycine_destroyed_per_photon)
            call showUVdestroyed
        endif

    end subroutine ajout_pertes
!---------------------------------------------------------------------------
    !> @author
    !> LAHIYANE Atik
    !
    ! DESCRIPTION:
    !> fait appel à toutes les fonctions qui vont representé le programme dans sa globalité.
    !> il sera appelé depuis le "main"
    !> correspondant
    ! REVISION HISTORY:
    ! TODO_dd_mmm_yyyy - TODO_describe_appropriate_changes - TODO_name
    !---------------------------------------------------------------------------
    subroutine run
        implicit none
        character(len=10)::name
        integer::c
        c=0
        call FileToArray
        print*,"--------------------------------------"
        print*,"|  Bienvenue dans le programme Orgamars  |"
        print*,"--------------------------------------"
        print*,""
        call show_values
        print*,""
        print*,"Veuillez entrer le nom de l'acide"
        read(5,*) name
        call research(name)
        print*,""
        call show_values
        print*,"Add an influence-------------------------------------------"
        print*,""
        print*,"Enter '1' to add a UV influence and get an assessment"
        print*,"Press '0' to quit"
        print*,""
        print*,"------------------------------------------------------"
        read(5,*) c
        select case (c)
        case (1)
            call bilan(name)
        case (0)
            print*, "Bye"
        end select
    end subroutine run
!---------------------------------------------------------------------------
    !> @author
    !> LAHIYANE Atik
    !
    ! DESCRIPTION:
    !> Fonction qui renvoie pour une longeur d'onde donnée et une latitude fixée la valeur du flux UV
    ! REVISION HISTORY:
    ! TODO_dd_mmm_yyyy - TODO_describe_appropriate_changes - TODO_name
    !>@param[in]: longeur_onde
    !>@param[out]:Uv_flux
    !---------------------------------------------------------------------------
real function Uv_flux(longeur_onde)
    real::longeur_onde,valeur,resultat
    valeur=longeur_onde-199
    if(ceiling(valeur)==valeur) then
        resultat=tab(int(valeur))
    else
        resultat=tab(ceiling(valeur)) +(tab(ceiling(valeur)+1)-tab(ceiling(valeur)))*(valeur-ceiling(valeur))
    endif
    uv_flux=resultat
end function Uv_flux
!---------------------------------------------------------------------------
    !> @author
    !> LAHIYANE Atik
    !
    ! DESCRIPTION:
    !> Fonction qui integre le flux UV entre deux bornes de longueur d'onde
    ! REVISION HISTORY:
    ! TODO_dd_mmm_yyyy - TODO_describe_appropriate_changes - TODO_name
    !> @param[in] a,b
    !> @param[out] aire
    !--------------------------------------------------------------------------
 real function aire(a,b)
 real::a,b,r,dx,x,ch
 integer:: n,i
 if(a>b) then
    ch=a
    a=b
    b=ch
endif
 n=190000
        r =0.0
	dx=(b-a)/float(n)
	do i=1,n-1
            x=a+float(i)*dx
            r=r+Uv_flux(x)
	enddo
        r=(r+(Uv_flux(a)+Uv_flux(b))/2.0)*dx
        aire=r
end function aire
!==================================================
!---------------------------------------------------------------------------
    !> @author
    !> LAHIYANE Atik
    ! DESCRIPTION:
    !> Créer un fichier .dat qui contient l'évolution du flux UV en fonction de la latitude
    ! REVISION HISTORY:
    ! TODO_dd_mmm_yyyy - TODO_describe_appropriate_changes - TODO_name
    !> @param[out] UV_vs_latitude.dat
    !--------------------------------------------------------------------------
subroutine calcul_tout
    implicit none
    integer::i,j,ierror2
    open (unit=15, file="UV_vs_latitude.dat", status="replace", action="write", iostat=ierror2)
    if (ierror2 /= 0) then
            print*, "Failed to open the file"
            stop
    end if
    print*,"Loading ..."
    do i=-80,80,5
        do j=1,100
            write(15,*) i,j,uv_integrale(i,(/200.0,250.0/))
        enddo
    enddo
    print*,"Processus finished 100%"
end subroutine calcul_tout
!==================================================
!---------------------------------------------------------------------------
    !> @author
    !> LAHIYANE Atik
    ! DESCRIPTION:
    !> Renvoie l'integrale de flux UV avec en entrée une latitude et un intervalle de longeur d'ondes
    ! REVISION HISTORY:
    ! TODO_dd_mmm_yyyy - TODO_describe_appropriate_changes - TODO_name
    !> @param[out] uv_integrale
    !--------------------------------------------------------------------------
real function uv_integrale(tet,lambda)
    integer::tet
    real,dimension(2)::lambda
    call extraire_colonne(tet)
    uv_integrale=aire(lambda(1),lambda(2))
    !calcul=*1e9*(i+200)/(3e8*(1.05e-34)*59354965)
end function uv_integrale
!===============================================
!---------------------------------------------------------------------------
    !> @author
    !> LAHIYANE Atik
    ! DESCRIPTION:
    !> Prend en entrée une sources et une valeur de UV
    !> et donne en sortie un fichier decrivant la diminution des UV en fonction de la profondeur
    ! REVISION HISTORY:
    ! TODO_dd_mmm_yyyy - TODO_describe_appropriate_changes - TODO_name
    !> @param[out] uv_integrale
    !--------------------------------------------------------------------------
subroutine diminution_general(Fsources,aire_uv,ans)
    implicit none
    real::aire_uv,fsources,diff,f
    real,dimension(1001)::reste
    integer::i,ans
    f=fsources
    call creer_fichiers("dim",ans)
    call interactGnu(ans)
    print*,"Calculating ..."
    call simul(fsources,reste,aire_uv,ans)
    call execute_command_line("rm dim_*",exitstat=i)
    call execute_command_line("exit",exitstat=i)
    call execute_command_line("avconv -f image2 -r 0.5 -i evolution_png/0%d.png -r 60 ./Simulation.mp4")
    !call execute_command_line("rm *.png")
end subroutine
!===============================================
!Fonction qui prend en entrée la profondeur et renvoie le flux UV correspondant en suivant la loi I(z)=Ioexp(-alpha*z)
real function diminution_uv_profondeur(z,Fuv,t)
implicit none
        integer::z,t
        real::Fuv,Io
        Io=Fuv
        diminution_uv_profondeur=Io*exp(-0.027*(z+1.15e-5*t))
end function diminution_uv_profondeur
!====================================================
subroutine simul(fsources,reste,aire_uv,year)
    integer::i,k,year,j,l
    real::fsources,aire_uv,diff
    real,dimension(1001)::reste
    do k=0,year
        print*,"Creating a file for the second",k," ..."
        if(k==0) then
            do i=0,1000
                do j=1,100
                    diff=fsources-diminution_uv_profondeur(i,aire_uv,0)
                    reste(i+1)=diff
                    if(diff<0) then
                        write(15,*) i,j,0
                    else
                        write(15,*) i,j,diff
                    endif
                enddo
            enddo
        else
            do i=0,1000
                do j=1,100
                    if(i==0) then
                        reste(i+1)=fsources
                    endif
                    diff=reste(i+1)-diminution_uv_profondeur(i,aire_uv,k)
                    reste(i+1)=diff
                    if(diff<0) then
                        write(15+k,*) i,j,0
                    else
                        write(15+k,*) i,j,diff
                    endif
                enddo
            enddo
            close(15+k)
        endif
    enddo
    print*,"Process finished"
    print*,"Creating the output png image"
    call execute_command_line("gnuplot gnuplot.gnu",exitstat=l)
    print*,"Finished."
    print*,"Please check the output images"
end subroutine simul
!====================================================
subroutine translate(array,taille,n)
    implicit none
    integer::taille,n,valeur,o
    real,dimension(taille)::array
    do o=n,taille
            valeur=array(o)
            array(o+1)=array(o+1)+valeur
    enddo
end subroutine translate

subroutine install_package
    implicit none
    integer::erro
    call execute_command_line("gnuplot ",exitstat=erro)
end subroutine install_package
end module Controlleur

