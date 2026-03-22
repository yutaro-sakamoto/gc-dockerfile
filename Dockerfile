# Build stage
FROM almalinux:9-minimal AS builder

ARG gnucobol_osscons_patch_version=dummy_value

SHELL ["/bin/bash", "-c"]

# install build dependencies
RUN microdnf update -y && \
    microdnf install -y gcc make autoconf automake libtool gettext bison flex \
    gmp-devel libdb-devel ncurses-devel tar gzip diffutils perl texinfo && \
    microdnf clean all

# build gnucobol-osscons-patch
RUN cd /root && \
    curl -L -o gnucobol-osscons-patch-${gnucobol_osscons_patch_version}.tar.gz \
    https://github.com/opensourcecobol/gnucobol-osscons-patch/archive/refs/tags/${gnucobol_osscons_patch_version}.tar.gz && \
    tar zxvf gnucobol-osscons-patch-${gnucobol_osscons_patch_version}.tar.gz && \
    cd gnucobol-osscons-patch-${gnucobol_osscons_patch_version} && \
    ./autogen.sh && \
    ./configure --prefix=/usr && \
    make && \
    make install && \
    rm -rf /root/gnucobol-osscons-patch-${gnucobol_osscons_patch_version}.tar.gz \
           /root/gnucobol-osscons-patch-${gnucobol_osscons_patch_version}

# Runtime stage
FROM almalinux:9-minimal

SHELL ["/bin/bash", "-c"]

# install runtime dependencies
RUN microdnf update -y && \
    microdnf install -y gcc gmp ncurses-libs libdb && \
    microdnf clean all && \
    rm -rf /var/cache/microdnf/*

# create required directories
RUN mkdir -p /usr/bin /usr/lib /usr/include /usr/share/gnucobol

# copy built files from builder stage
COPY --from=builder /usr/bin/cobc /usr/bin/cobc
COPY --from=builder /usr/bin/cobcrun /usr/bin/cobcrun
COPY --from=builder /usr/bin/cob-config /usr/bin/cob-config
COPY --from=builder /usr/lib64/libcob* /usr/lib64/
COPY --from=builder /usr/lib64/gnucobol/ /usr/lib64/gnucobol/
COPY --from=builder /usr/include/libcob.h /usr/include/libcob.h
COPY --from=builder /usr/include/libcob/ /usr/include/libcob/
COPY --from=builder /usr/share/gnucobol/ /usr/share/gnucobol/

# update library cache
RUN ldconfig

# add sample programs
ADD cobol_sample /root/cobol_sample

WORKDIR /root/

CMD ["/bin/bash"]
