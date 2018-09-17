#!/bin/bash -e
# =================================================================
#          #     #                 #     #
#          ##    #   ####   #####  ##    #  ######   #####
#          # #   #  #    #  #    # # #   #  #          #
#          #  #  #  #    #  #    # #  #  #  #####      #
#          #   # #  #    #  #####  #   # #  #          #
#          #    ##  #    #  #   #  #    ##  #          #
#          #     #   ####   #    # #     #  ######     #
#
#       ---   The NorNet Testbed for Multi-Homed Systems  ---
#                       https://www.nntb.no
# =================================================================
#
# Container-based UDPPing for NorNet Edge
#
# Copyright (C) 2018 by Thomas Dreibholz
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Contact: dreibh@simula.no


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

CONTAINER=${DIR##*/}
CONTAINERTAG=dreibh/udpping
TESTNAME="test-${CONTAINER}"

echo "Building:"
./build.sh

echo "Tagging:"
# Create tag (no push needed):
docker tag ${CONTAINER} ${CONTAINERTAG}
#./push.sh

echo "Stopping previous run:"
docker kill ${TESTNAME} || true
docker container rm ${TESTNAME} || true

echo "Starting:"
mkdir -p /run/shm/monroe-results
docker run --name ${TESTNAME} \
   -v /run/shm/monroe-results:/monroe/results \
   -v monroe-config:/monroe/config:ro \
   ${CONTAINERTAG} &

sleep 1

echo "Shell:"
docker exec -i -t ${TESTNAME} /bin/bash
