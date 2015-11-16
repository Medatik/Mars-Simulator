reset
unset key; unset border
set tics scale 0
set lmargin screen 0
set bmargin screen 0
set rmargin screen 1
set tmargin screen 1
set format ''

set mapping spherical
set angles degrees
set hidden3d front
# Set xy-plane to intersect z axis at -1 to avoid an offset between the lowest z
# value and the plane
set xyplane at -1
set view 56,81

set parametric
set isosamples 25
set urange[0:360]
set vrange[-90:90]
set cbrange[3e20:1e21]

set palette gamma 1.0
r = 0.99
splot 'UV_vs_latitude.dat' u 2:1:(1):3 w pm3d, \
      r*cos(v)*cos(u),r*cos(v)*sin(u),r*sin(v) w l ls 2
