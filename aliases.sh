#! /bin/bash 
# Date: 24/12/2019 
# Author: Shon Paz 
# Description: This script performs pg log trimming for a given osd host 

##########################################################################

# make OSD node enter maintenance mode (set flags for no data removal and stop osd processes)
alias enter_maintenance=$(echo ceph\ osd\ set\ {'nobackfill &&','norebalance &&','noout &&','norecover'} "&&" sleep 5 "&&" systemctl stop ceph-osd.target)

# make OSD node leave maintenance mode (start all osd processes and unset flags to recover)
alias leave_maintenance=$(echo sleep 5 "&&" systemctl start ceph-osd.target "&&" ceph\ osd\ unset\ {'nobackfill &&','norebalance &&','noout &&','norecover'})

# outputs the osd ids located on the specific node injected as argument
alias tree=$(echo ceph osd ls-tree "$@")

# fliter out ceph logs via pattern given
alias ceph_locate=$(echo "cat /var/log/ceph/* | grep $@")


# filter slow requests per osd, presents a count 
alias slow_req_by_osd=$(echo egrep \'slow request 3[0-9]\.\' /var/log/ceph/ceph.log "|" grep -v subops "|" awk \'{print $3}\' "|" sort -g "|" uniq -c)

# filter slow requests diffrenciated by type, presents a count
alias slow_req_by_type=$(echo egrep \'slow request 3[0-9]\.\' /var/log/ceph/ceph.log "|" sed -e \'s/^.*currently//\' -e \'s/ from .*$//\' "|" sort -g "|" uniq -c)
