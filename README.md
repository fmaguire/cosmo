# Recoloring  the  Colored  de  Bruijn  Graph
 A heuristic algorithm to recolor a colored DBG, with orders of magnitude less number of colors, while the original colors are distinguishable. Colors can be either samples or reads.
 ### Prerequisites

VARI and its all Prerequisites

### Installing
```
#Fetch software and setup directories
git clone https://github.com/cosmo-team/cosmo
cd cosmo
git checkout Recoloring
Follow all steps listed in Building notes of VARI (https://github.com/cosmo-team/cosmo/tree/VARI#building-notes)
```
# Input
Either .fasta or .fastq files.
# Output
Color matrix constructed with orders of magnitude less number of colors and compressed using Elias-Fano coding 
## Running 
```
#count the k-mers
mkdir -p kmc_temp
ls -1 --color=no *.fasta |xargs -l -i echo "~/kmc -b -fq -k32 -ci0 -cs250 {} {}.kmc kmc_temp" >kmercount.sh
source kmercount.sh
ls -1 --color=no *.fasta |xargs -l -i echo "~/kmc_tools sort {}.kmc {}.kmc.sorted " >kmercountsort.sh
source kmercountsort.sh
ls -1 --color=no *.fasta |xargs -l -i echo "{}.kmc.sorted" > filtered_kmc2_list
#Construct the de Bruijn graph
cosmo-pack -k filtered_kmc2_list

#make a list of input files
ls *.fasta > list.txt

#construct the read-colored matrix with reduced number of colors:
reduce_color


```
##Paper
https://link.springer.com/chapter/10.1007/978-3-030-00479-8_1
## Authors
Bahar Alipanahi, Alan Kuhnle and Christina Boucher

