module Pertes
    implicit none
    doubleprecision,parameter::k=1.38d-23
    doubleprecision,parameter::h=6.63d-34
    doubleprecision,parameter::c=3e8
    real,parameter::t=5780
    real,parameter::Omega=7e-10
    real,parameter::d=2.27e8
    real,parameter::pi=3.141
    real,parameter::p=88775
    real,parameter::Rsm=2.27e8

    contains
    !---------------------------------
    !Flux emitted by sun
    function emitted_solar(lamb)
    doubleprecision::emitted_solar,exposant
    real::lamb
    exposant=(h*c)/(lamb*k*t)
    print*,exp(exposant),((2*h*(c**2))/(lamb**5))
    emitted_solar=((2*h*(c**2))/(lamb**5))/(exp(exposant)-1)
    end function emitted_solar
    !----------------------------------
    !cos(z) calculating function
    function calcul_z(lat,t)
        real::lat
        real::ls
        real::t
        real::calcul_z
        ls=250
        calcul_z=sin(lat)*sin(25.2)*sin(ls)+cos(lat)*(1-(sin(25.2)*sin(ls))**2)*cos(2*pi*t/p)
    end function calcul_z
    !Flux emitted by sun on top of mars atmospehre

    function emitted_solar_on_top_of_atmosphere(lat,lamb)
        real::emitted_solar_on_top_of_atmosphere
        real::lat,lamb
        real::calc
        calc=calcul_z(lat,10.0)
        emitted_solar_on_top_of_atmosphere=calc*emitted_solar(lamb)*(d/Rsm)**2
    end function emitted_solar_on_top_of_atmosphere

    !Flux emitted at surface of mars
    function Flux_surface(lat,lamb,density,absorp)
        real:: lat,density,absorp,lamb
        real::flux_surface
        flux_surface=emitted_solar_on_top_of_atmosphere(lat,lamb)*exp(-density*absorp)
    end function Flux_surface

    !All_routine

end module Pertes
