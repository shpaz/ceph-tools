#! /bin/bash 
# Date: 24/12/2019 
# Author: Shon Paz 
# Description: This script performs pg log trimming for a given osd host 

##########################################################################

# Performs as prefix for the osd filesystem data path 
OSD_PATH_PREFIX='/var/lib/ceph/osd/ceph'

# Runs on each pgs for a given osd via nested loop 
for osd_id in `ceph osd ls-tree $HOSTNAME`; do 
    pgs_list=`ceph-objectstore-tool --data-path "${OSD_PATH_PREFIX}-${osd_id}" --op list-pgs`
    
    for pg_id in $pgs_list; do
        CEPH_ARGS="--osd-max-pg-log-entries=5000 --osd-pg-log-trim-max=1000" \
        ceph-objectstore-tool --data-path "${OSD_PATH_PREFIX}-${osd_id}" --pgid $pg_id --op trim-pg-log 
        
        # sleep between trimming the next pgs 
        sleep 5 
    done
     
    # sleep between osds
    sleep 20
done
