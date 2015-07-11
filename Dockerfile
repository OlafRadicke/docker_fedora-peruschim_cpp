# DOCKER-VERSION 0.3.4
# image olafradicke/fedora-peruschim_cpp:latest
FROM fedora:22
MAINTAINER Olaf Raicke <olaf@atix.de>

ENV MYSQL-SUPPORT yes
ENV POSTGRESQL-SUPPORT yes
ENV SQLITE-SUPPORT yes
ENV REPLICATION_SUPPORT yes
ENV ORACLE-SUPPORT no

# Install develop tools
RUN dnf -y install gcc-c++ make wget zip zlib-devel
RUN dnf -y install libtool mysql++-devel sqlite-devel openssl-devel postgresql-devel

##### Compile and install cxxtools #####
WORKDIR /tmp
RUN  wget https://github.com/maekitalo/cxxtools/archive/master.zip
RUN ls -lah
RUN  unzip  master.zip
WORKDIR /tmp/cxxtools-master
RUN /usr/bin/ls -lah
RUN autoreconf -i
RUN /bin/bash ./configure
RUN make
RUN make install

RUN  echo "/usr/local/lib" >  /etc/ld.so.conf.d/cxxtools.conf
RUN  ldconfig
RUN  rm -Rvf /tmp/master.zip /tmp/cxxtools-master

##### Compile and install tntdb #####
WORKDIR /tmp/
RUN  wget https://github.com/maekitalo/tntdb/archive/master.zip
RUN /usr/bin/ls -lah
RUN  unzip  master.zip
RUN /usr/bin/ls -lah
WORKDIR /tmp/tntdb-master
RUN /usr/bin/ls -lah
RUN autoreconf -i
RUN /bin/bash ./configure --with-mysql=$MYSQL-SUPPORT --with-postgresql=$POSTGRESQL-SUPPORT --with-sqlite=$SQLITE-SUPPORT  --with-replication=$REPLICATION_SUPPORT --with-oracle=$ORACLE-SUPPORT
RUN make
RUN make install

RUN echo "/usr/local/lib" >  /etc/ld.so.conf.d/tntdb.conf
RUN ldconfig
RUN rm -Rvf /tmp/tntdb-master /tmp/master.zip


##### Compile and install tntdb #####
WORKDIR /tmp
RUN  wget https://github.com/maekitalo/tntnet/archive/master.zip
RUN  unzip  master.zip
WORKDIR /tmp/tntnet-master
RUN /usr/bin/ls -lah
RUN autoreconf -i
RUN /bin/bash ./configure
RUN make
RUN make install

RUN  echo "/usr/local/lib" >  /etc/ld.so.conf.d/tntnet.conf
RUN  ldconfig
RUN rm -Rvf /tmp/tntnet-master /tmp/master.zip

##### Compile and install peruschim_cpp #####

WORKDIR /tmp
RUN  weget https://github.com/OlafRadicke/peruschim_cpp/archive/master.zip
RUN  unzip  master.zip
WORKDIR /tmp/peruschim_cpp-master
RUN /usr/bin/ls -lah
RUN autoreconf -i
RUN ./configure
RUN make
RUN mkdir -p /srv/peruschim_cpp/
RUN cp src/peruschim_cpp /srv/peruschim_cpp/
RUN rm -Rvf /tmp/peruschim_cpp-master /tmp/master.zip


EXPOSE 8008

VOLUME ["/srv/peruschim_cpp/peruschim_cpp.conf:/etc/peruschim_cpp.conf"]

CMD ["/srv/peruschim_cpp/peruschim_cpp"]

