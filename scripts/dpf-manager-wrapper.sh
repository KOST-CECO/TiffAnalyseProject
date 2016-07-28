#!/bin/sh 

if [ $# -ne 2 ]
then
	echo "usage: $0 source logfile"
	exit 1
fi

# run dpf-manager ------------------------------------------------------------------

LOGDIR=/home/mkaiser/DPF\ Manager/reports/log
INPUT=`readlink -f $1`

if ! [ -f "${INPUT}" ]
then
	echo "${INPUT} file not found"
	exit 1
fi

if [ `file -b --mime-type "${INPUT}"` != "image/tiff" ]
then
	echo "${INPUT} is not an accepted format"
	exit 1
fi

rm -rf "${LOGDIR}"
mkdir -p "${LOGDIR}" 

/usr/bin/dpf-manager -s -configuration ~/DPF\ Manager/baseline_simple.dpf -o "${LOGDIR}" "${INPUT}" 

rm -f "${LOGDIR}"/summary.xml

cat "${LOGDIR}"/*.xml > $2

