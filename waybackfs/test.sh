#!/bin/bash

set -euo

DESTINATION=/mnt/destination
FS_NAME=WAYBACKFS
SEED=420
BONNIE_ARGS="-d ${DESTINATION} -s 1G -n 15 -m ${FS_NAME} -b -u root -q -z ${SEED} -x 2"
OUTPUT_DIRECTORY=/vagrant/out

function setup {
	mkdir -p /mnt/source
	mkdir -p $DESTINATION
	wayback -- /mnt/source $DESTINATION
}

function teardown {
	umount $DESTINATION
}

function test {
	mkdir -pv $OUTPUT_DIRECTORY
	echo "Running bonnie++ benchmark..."

	df >> $OUTPUT_DIRECTORY/df_before.txt
	bonnie++ $BONNIE_ARGS >> $OUTPUT_DIRECTORY/out.csv
	df >> $OUTPUT_DIRECTORY/df_after.txt
}

function main {
	setup
	test
	teardown
}

main
