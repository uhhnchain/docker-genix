FROM uhhnchain/crypto-builder as BASE

ENV repository https://github.com/genix-project/genix.git

WORKDIR /tmp
RUN git clone $repository repository
WORKDIR /tmp/repository/depends
RUN bash -c "make -j $(nproc) NO_QT=1"
WORKDIR /tmp/repository
RUN ./autogen.sh
RUN ./configure --prefix=$PWD/depends/x86_64-pc-linux-gnu
RUN bash -c "make -j $(nproc) STATIC=1"

FROM debian

ENV modulename genix
ENV p2p 43649
ENV rpc 9998

# install
COPY --from=BASE "/tmp/repository/src/${modulename}d" /usr/local/bin
COPY --from=BASE "/tmp/repository/src/${modulename}-cli" /usr/local/bin
COPY --from=BASE "/tmp/repository/src/${modulename}-tx" /usr/local/bin

# create default data directory
RUN mkdir /root/.${modulename}
RUN bash -c "echo \"rpcuser=${modulename}rpc\" > /root/.$modulename/$modulename.conf"
RUN bash -c "echo \"rpcpassword=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)\" >> /root/.$modulename/$modulename.conf"

# P2P
EXPOSE $p2p

# RPC
EXPOSE $rpc

CMD $modulename"d"
