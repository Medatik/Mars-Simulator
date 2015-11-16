reset
set title "Présence du flux en UV sur la surface en fonction de la latitude : Vue de face "
set cbrange [1e21:3.8e20]
set xrange[*:*]
set yrange[85:-85]
unset xtics
set cblabel "molecules/(km².yrm)"
set pm3d; set palette
set palette gamma 1.0
set terminal pngcairo size 800,400 enhanced font 'Verdana,10
set ylabel "latitude en °"
set output 'test.png'
plot 'UV_vs_latitude.dat' u 2:1:3 w image notitle

