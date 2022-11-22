# FROM nvcr.io/nvidia/l4t-ml:r32.6.1-py3
FROM nvcr.io/nvidia/l4t-pytorch:r32.7.1-pth1.10-py3
WORKDIR /root

RUN apt update
RUN apt -y install libssl1.1 \
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

# Install DeepStreamSDK using tar package.
ENV DS_REL_PKG deepstream_sdk_v6.0.1_jetson.tbz2

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

RUN git clone --branch v1.1.0 https://github.com/NVIDIA-AI-IOT/deepstream_python_apps.git

RUN apt -y install libgirepository1.0-dev gcc libcairo2-dev pkg-config python3-dev gir1.2-gtk-3.0
RUN pip3 install pycairo
RUN pip3 install PyGObject
RUN pip3 install pyds-ext
RUN pip3 install pyds
RUN pip3 install types-pkg-resources