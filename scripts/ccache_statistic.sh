#!/bin/bash - 
#===============================================================================
#
#          FILE: ccache_statistic.sh
# 
#         USAGE: ./ccache_statistic.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 11/05/2012 11:41:33 PM ICT
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
CCACHE_DIR=/mnt/data2/tmp/ccache ccache -s

