# Docker Seafile client, help you mount a Seafile library as a volume.
# Copyright (C) 2019, flow.gunso@gmail.com
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
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

FROM debian:jessie-slim

# Prevent the packages installation to halt.
ENV DEBIAN_FRONTEND noninteractive

# Copy over the seafile repository.
COPY assets/seafile.list /etc/apt/sources.list.d/

# Safely import Seafile APT key, then install both seafile-cli and supervisord.
COPY utils/build/import-seafile-apt-key.sh /
RUN /bin/bash /import-seafile-apt-key.sh ;\
    apt-get update ;\
    apt-get install -o Dpkg::Options::="--force-confold" -y seafile-cli supervisor
RUN rm -f /import-seafile-apt-key.sh

# Create the seafile client user.
ENV UNAME=seafuser
ENV UID=1000
ENV GID=1000
RUN groupadd -g $GID -o $UNAME ;\
    useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME

# Copy over the Docker entrypoint.
COPY assets/docker-entrypoint.sh /entrypoint.sh

# Copy over the required files for Seafile/SupervisorD.
COPY assets/supervisord.conf /home/seafuser/
COPY assets/infinite-seaf-cli-start.sh /home/seafuser/
COPY assets/seafile-entrypoint.sh /home/seafuser/entrypoint.sh
RUN mkdir /volume

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
