# Gnuplot script to plot two column Synspec data from subdirectory.
# It will list all files from subdir and incorporate into multiplot.
# Usage is:
# gnuplot -c test.gp <relative_dir_with_files>/  --persists
#
# Author: Filip Hubík, Red Hat Brno, Vega group
# ----------------------------------------------------------------------------

# This script HAS to be started with argument!
DATADIR = ARG1
set title "Synspec graph of datadir: ".DATADIR

# print to image as medium res PNG
set terminal png
set terminal png size 1600,900
set output DATADIR.'/file.png'

# Customize line styles
# Note: These will be used in final plot cycle in order as indexed
set style line 1 lc rgb 'red' lt 1 lw 2
set style line 2 lc rgb 'green' lt 2 lw 5
set style line 3 lc rgb 'blue' lt 4 lw 2

# Font style for legend
set key samplen 10 spacing 3 font ",10"

# Graph params
#set size 0.5,0.5
#set origin 0.5,0.5
#set dummy wnt
unset logscale x
set ylabel "intensity" offset 1,0
set xlabel "angstrom"
#set xrange [3600:5000]
set xrange [0000:15000]
#set xrange [1500:1600]
#set xtics 0,5,20
#set yrange [0:2e7]
#set ytics 0, .5, 2.0
set mytics 10
set mxtics 10

# Iterate thru all files in DATADIR
LS = "ls -1 "
# Construct Linux command to obtain the content of DATADIR as only filename, dirname not included,
# that will come later
LS_COMMAND = sprintf("%s %s/ | grep -v png", LS, DATADIR)
# Obtain files to iterate thru
FILES = system(LS_COMMAND)

# Plot files using full path (still relative to main directory) and use only filename in legend
# Unpacked cycle rewritten into gnuplot commands could look like example:
#plot    "datafiles/synspec.tlusty.spectra" using 1:2 title 'tlusty10k' with linespoints ls 1, \
#        "datafiles/synspec.kurucz.spectra" using 1:2 title 'kurucz10k' with linespoints ls 2, \
#        "datafiles/kurucz.10k.4.spectrum" using 1:2 title 'kurucz10knew' with linespoints ls 3
#
plot for [i=1:words(FILES)] sprintf("%s/%s", DATADIR, word(FILES,i)) u 1:2 title word(FILES,i) w l ls i
