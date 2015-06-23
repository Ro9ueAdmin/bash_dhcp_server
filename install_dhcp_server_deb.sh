#!/bin/bash
#******************************************************************************

# Copyright 2015 Clark Hsu
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#******************************************************************************
# How To

#******************************************************************************
# Mark Off this section if use as lib

PROGNAME=$(basename $0)
AUTHOR=clark_hsu
VERSION=0.0.1

#******************************************************************************
#echo "Begin: $(basename $0)"
#set -e # Exit on error On
#set -x # Trace On
#******************************************************************************

usage()
{
cat << EOF

Usage: $0 options

This script is clean old kernel after install new kernel after dist-upgrade.

OPTIONS:
    -h | --help             Usage
    -v | --version          Version

EOF
exit 1
}

version()
{
cat << EOF

Program: ${PROGNAME}
Author: ${AUTHOR}
Version: ${VERSION}

EOF
exit 1
}

#******************************************************************************

PARAMETERS="$@"
while [[ $# > 0 ]]
do
    OPTION="$1"
    case ${OPTION} in
        -h|--help)
            usage
            ;;
        -v|--version)
            version
            ;;
        -i|--install)
            ACTION="-i"
			ADD_APT_REPO="add-apt-repository -y"
            APT_GET="apt-get install -y --force-yes"
            ;;
        -u|--uninstall)
            ACTION="-u"
			ADD_APT_REPO="add-apt-repository -y"
            APT_GET="apt-get remove --purge -y"
            ;;
        -d|--download-only)
            ACTION="-d"
			ADD_APT_REPO="add-apt-repository -y"
            APT_GET="apt-get install --download-only --reinstall -y"
            ;;
        *)
			# Others / Unknown Option
            usage
            ;;
    esac
    shift # past argument or value
done

if [ $# == 0 ]; then
    ACTION="-i"
    ADD_APT_REPO="add-apt-repository -y"
    APT_GET="apt-get install -y --force-yes"
fi

#******************************************************************************
# Design for Root Only

if [[ ${UID} -ne 0 ]]; then
    echo "[Warning] This script was designed for root user.  Please rerun the script as root user!"
    exit 1
fi

#******************************************************************************
# Required User Actions


#******************************************************************************
# Source

CMD_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)
TOP_DIR=$(cd $(dirname "$0") && pwd)
source ${TOP_DIR}/setup.conf

if [ -e "${TOP_DIR}/bash_lib" ]; then
    source ${TOP_DIR}/bash_lib/functions.sh
elif  [ -e "${TOP_DIR}/../bash_lib" ]; then
    source ${TOP_DIR}/../bash_lib/functions.sh
else
    source ${TOP_DIR}/functions.sh
fi

#******************************************************************************
# Functions

#******************************************************************************
# Prerequisites

#******************************************************************************
# Main Program

${APT_GET} isc-dhcp-server

set_configuration_file \
    infile:${CONF}/etc.default.isc-dhcp-server.conf \
    outfile:/etc/default/isc-dhcp-server \
    "<CLUSTER_DHCP_SERVER_INTERFACE>:${CLUSTER_DHCP_SERVER_INTERFACE}"

set_configuration_file \
    infile:${CONF}/etc.dhcp.dhcpd.conf \
    outfile:/etc/dhcp/dhcpd.conf \
    "<CLUSTER_DCHP_DOMAIN>:${CLUSTER_DCHP_DOMAIN}" \
    "<CLUSTER_DCHP_DOMAIN_SERVER>:${CLUSTER_DCHP_DOMAIN_SERVER}" \
    "<CLUSTER_NET_IP1_IP2_IP3>:${CLUSTER_NET_IP1_IP2_IP3}" \
    "<CLUSTER_NET_IP_FROM>:${CLUSTER_NET_IP_FROM}" \
    "<CLUSTER_NET_IP_TO>:${CLUSTER_NET_IP_TO}"

service isc-dhcp-server restart
service status isc-dhcp-server

#******************************************************************************
#set +e # Exit on error Off
#set +x # Trace Off
#echo "End: $(basename $0)"
exit 0
#******************************************************************************

