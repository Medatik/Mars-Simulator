reset
set title "Présence des molécules en fonction de la profondeur"
set tics scale 0.5
set cbrange [0:2.7]
set xrange[*:*]
set yrange[1000:0]
unset xtics
set cblabel "1e16 molecules/(km².yrm)"
set pm3d; set palette
set palette gamma 1.0
set ylabel "depth(µm)"
plot 'diminution_en_profondeur_one.dat' u 2:1:3 w image notitle
