#!usr/bin/env bash

#define variables
input_directory=$1
output_directory=$2

#make output directory
mkdir --parent $output_directory

#create a log file
touch ${output_directory}/bam2bigwig_log.txt

#make conda environment
mamba create --name bam2bigwig -y deeptools samtools >> ${output_directory}/bam2bigwig_log.txt

#activate the environment
source $(dirname $(dirname $(which mamba)))/etc/profile.d/conda.sh
conda activate bam2bigwig

#for loop to convert bam files in input directory to bigwigs in output directory
bam_files=$(ls ${input_directory}/*.bam)

for file in ${bam_files[@]}; do
	input=$file
	echo bam file to be converted to bw file: $input >> ${output_directory}/bam2bigwig_log.txt
	input_wo_suffix=${file::-4}
	output=$output_directory/$(basename $input_wo_suffix).bw
	nice samtools index -b $input >> ${output_directory}/bam2bigwig_log.txt 2>&1 
	nice bamCoverage -b $input -o $output >> ${output_directory}/bam2bigwig_log.txt 2>&1
done

#remove intermediary .bam.bai files
rm ${input_directory}/*.bam.bai >> ${output_directory}/bam2bigwig_log.txt 2>&1

#end by echoing my name
echo Renée Joosten, s1009390
