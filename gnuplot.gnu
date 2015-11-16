 set title 'Présence des molécules en fonction de la profondeur' 
 set tics scale 0.5
 set cbrange [1e16:2.0005e16]
 set terminal pngcairo size 800,400 enhanced font 'Verdana,10'
 set xrange[*:*]
 set yrange[1000:0]
 unset xtics
 set cblabel 'molecules/(km².yrm)' 
 set pm3d; set palette
 set palette gamma 1.0
 set ylabel 'depth(µm)' 
 plot 'dim_01.dat' u 2:1:3 w image notitle
 set output './01.png'
 plot 'dim_02.dat' u 2:1:3 w image notitle
 set output './02.png'
 plot 'dim_03.dat' u 2:1:3 w image notitle
 set output './03.png'
 plot 'dim_04.dat' u 2:1:3 w image notitle
 set output './04.png'
 plot 'dim_05.dat' u 2:1:3 w image notitle
 set output './05.png'
 plot 'dim_06.dat' u 2:1:3 w image notitle
 set output './06.png'
 plot 'dim_07.dat' u 2:1:3 w image notitle
 set output './07.png'
 plot 'dim_08.dat' u 2:1:3 w image notitle
 set output './08.png'
 exit
