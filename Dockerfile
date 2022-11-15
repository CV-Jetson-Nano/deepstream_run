# Set L4T_VERSION, example: 10.2
ARG L4T_VERSION
# Use L4T base docker
FROM nvcr.io/nvidian/nvidia-l4t-base:${L4T_VERSION}

# Install dependencies
RUN apt-get update && \
      DEBIAN_FRONTEND=noninteractive      apt-get install -y --no-install-recommends \
      rsyslog git \
           tzdata \
           libgstrtspserver-1.0-0 \
           libjansson4 \
           libglib2.0 \
           libjson-glib-1.0-0 \
           librabbitmq4 \
           gstreamer1.0-rtsp \
           libcurl4-openssl-dev ca-certificates

#Install libnvvpi1 and vpi1-dev
ADD https://repo.download.nvidia.com/jetson/common/pool/main/libn/libnvvpi1/libnvvpi1_1.0.15_arm64.deb /root
ADD https://repo.download.nvidia.com/jetson/common/pool/main/v/vpi1-dev/vpi1-dev_1.0.15_arm64.deb /root

RUN dpkg -X /root/libnvvpi1_1.0.15_arm64.deb /

RUN dpkg -X /root/vpi1-dev_1.0.15_arm64.deb /

RUN rm /root/libnvvpi1_1.0.15_arm64.deb  \
      /root/vpi1-dev_1.0.15_arm64.deb

RUN ldconfig

RUN sudo apt install \
    libssl1.1 \
    libgstreamer1.0-0 \
    gstreamer1.0-tools \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-libav \
    libgstreamer-plugins-base1.0-dev \
    libgstrtspserver-1.0-0 \
    libjansson4 \
    libyaml-cpp-dev

RUN git clone https://github.com/edenhill/librdkafka.git

RUN cd librdkafka \
git reset --hard 7101c2310341ab3f4675fc565f64f0967e135a6a \
./configure \
make \
make install

RUN mkdir -p /opt/nvidia/deepstream/deepstream-6.0/lib
RUN cp /usr/local/lib/librdkafka* /opt/nvidia/deepstream/deepstream-6.0/lib

# Install DeepStreamSDK using tar package.
ENV DS_REL_PKG deepstream_sdk_v6.0.0_jetson.tbz2

COPY "${DS_REL_PKG}"  \
/

RUN DS_REL_PKG_DIR="${DS_REL_PKG%.tbz2}" && \
cd / && \
tar -xvf "${DS_REL_PKG}" -C / && \
cd /opt/nvidia/deepstream/deepstream-6.0 && \
./install.sh && \
cd / && \
rm -rf "/${DS_REL_PKG}"

RUN ldconfig

CMD ["/bin/bash"]
WORKDIR /opt/nvidia/deepstream/deepstream

ENV LD_LIBRARY_PATH /usr/local/cuda-10.2/lib64
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES all