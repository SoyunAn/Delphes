#!/bin/bash

## Find out the job index and which file to process
I=$((${2}+1))
DATASET=${1}
echo $DATASET
[ $I -gt `cat samples/${DATASET}.txt | wc -l` ] && exit ## Skip if job index exceeds number of files to process
FILEIN=`cat samples/${DATASET}.txt | sed -n "${I}p"`

## Set basic envvars - we need cmssw FWLite
WORKDIR=$_CONDOR_JOB_IWD
export SCRAM_ARCH=slc6_amd64_gcc630
source /cvmfs/cms.cern.ch/cmsset_default.sh
cd /cms/ldap_home/syan/work/CMSSW_9_4_9_cand2/src
eval `scramv1 runtime -sh`
cd $_CONDOR_SCRATCH_DIR
OUTDIR=$WORKDIR/ttbar_delphes/$DATASET
if [ ! -d $OUTDIR ]; then
     mkdir -p $OUTDIR
#    mkdir -p $OUTDIR/64x64_32PU
#    mkdir -p $OUTDIR/224x224_noPU
#    mkdir -p $OUTDIR/224x224_32PU
fi

## Print out what to do in this job.
echo "+ Job index=$I"
echo "+ CMSSW=$CMSSW_VERSION"
echo "+ FILEIN=$FILEIN"
echo "+ OUTDIR=$OUTDIR"

## Move to the Delphes directory
df -h $WORKDIR
df -h $_CONDOR_SCRATCH_DIR

## Run Delphes and do the simulation and produce images for the 32-pu case
cd $WORKDIR/Delphes
./DelphesCMSFWLite $WORKDIR/Delphes/cards/delphes_card_CMS.tcl $OUTDIR/${DATASET}-powheg-${I}.root $FILEIN
