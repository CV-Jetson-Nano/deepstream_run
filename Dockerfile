FROM nvcr.io/nvidia/l4t-ml:r32.6.1-py3

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

RUN wget https://developer.nvidia.com/deepstream_sdk_v6.0.1_jetsontbz2
# RUN tar -xvf deepstream_sdk_v6.0.1_jetsontbz2.tbz2 -C /
# RUN cd /opt/nvidia/deepstream/deepstream-6.0.1

# RUN ./install.sh
# RUN ldconfig

# RUN git clone --branch v1.1.0 https://github.com/NVIDIA-AI-IOT/deepstream_python_apps.git