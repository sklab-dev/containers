############################
# STEP 1 build executable binary
############################
FROM alpine:3.6 AS builder

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

LABEL maintainer="Aviator" \
  discord="Aviator#1024"

ENV DB_VERSION=4.8.30.NC 
RUN deps="alpine-sdk curl autoconf automake libtool boost-dev openssl-dev libevent-dev git" && \
  apk add --no-cache -U $deps dumb-init boost boost-program_options libevent libssl1.0 && \
  curl -L http://download.oracle.com/berkeley-db/db-$DB_VERSION.tar.gz \
  | tar zx && \
  cd /db-$DB_VERSION/build_unix && \
  ../dist/configure \
  --prefix=/opt/db \
  --enable-cxx \
  --disable-shared \
  --with-pic && \
  make -j 10 &&\
  make install && \
  mkdir /wallet &&\
  cd /wallet && \
  git clone https://github.com/ProjectMerge/merge.git . &&\   
 # sed -i '7s/.*/define(_CLIENT_VERSION_IS_RELEASE, true)/' ./configure.ac  &&\
  #sed -i '301i        obj.push_back(Pair("ipaddress", strHost));' ./src/rpc/masternode.cpp &&\
  ./autogen.sh && \ 
  ./configure LDFLAGS=-L/opt/db/lib CPPFLAGS=-I/opt/db/include && \ 
  make -j 10 &&\
  make install && \ 
  strip /usr/local/bin/merged &&\ 
  strip /usr/local/bin/merge-cli &&\ 
  rm /usr/local/bin/merge-tx &&\ 
  adduser -D wallet && \ 
  apk del $deps && \
  rm -r /opt/db/docs /var/cache/apk/* /wallet /db-$DB_VERSION 
############################
# STEP 2 build a small image
############################
FROM alpine:3.6

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

# Install SSL Certs
RUN apk add --no-cache ca-certificates boost boost-program_options libevent libssl1.0 tini &&\
  adduser -D wallet
# Copy our static executable.
COPY --from=builder /usr/local/bin/merged /usr/local/bin/
COPY --from=builder /usr/local/bin/merge-cli /usr/local/bin/
USER wallet 
RUN mkdir /home/wallet/.merge
VOLUME ["/home/wallet/.merge"]
EXPOSE 52000/tcp 

#Run the Phantom Binary
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/usr/local/bin/merged","-printtoconsole"]