FROM ubuntu:16.04

# install build deps
RUN apt-get update
RUN apt-get install -y software-properties-common python-software-properties
RUN add-apt-repository ppa:ethereum/ethereum
RUN apt-get update
RUN apt-get install -y build-essential git wget unzip libdb-dev libleveldb-dev libsodium-dev zlib1g-dev libtinfo-dev solc sysvbanner wrk

# install constellation
ENV CVER="0.3.2"
ENV CREL="constellation-$CVER-ubuntu1604"
RUN wget -q https://github.com/jpmorganchase/constellation/releases/download/v$CVER/$CREL.tar.xz
RUN tar xfJ $CREL.tar.xz
RUN cp $CREL/constellation-node /usr/local/bin && chmod 0755 /usr/local/bin/constellation-node
RUN rm -rf $CREL

# install golang
ENV GOREL=go1.9.3.linux-amd64.tar.gz
RUN wget -q https://dl.google.com/go/$GOREL
RUN tar xfz $GOREL
RUN mv go /usr/local/go
RUN rm -f $GOREL
ENV PATH=$PATH:/usr/local/go/bin

# make/install quorum
RUN git clone https://github.com/jpmorganchase/quorum.git
WORKDIR /quorum
RUN git checkout tags/v2.0.1
RUN make all
RUN cp build/bin/geth /usr/local/bin
RUN cp build/bin/bootnode /usr/local/bin
WORKDIR /

# install porosity
RUN wget -q https://github.com/jpmorganchase/quorum/releases/download/v1.2.0/porosity
RUN mv porosity /usr/local/bin && chmod 0755 /usr/local/bin/porosity

# bring in quorum-examples and enable cors for web3js users
WORKDIR /
RUN git clone https://github.com/jpmorganchase/quorum-examples
RUN sed -i -e 's/geth --datadir/geth --rpccorsdomain "*" --datadir/g' quorum-examples/examples/7nodes/raft-init.sh

# create non-root user
RUN groupadd -g 1000 quorumgroup
RUN useradd -u 161711 quorum
RUN chown -R quorum:quorumgroup /quorum /quorum-examples
RUN chmod -R 755 /quorum /quorum-examples
USER quorum

EXPOSE 22000
