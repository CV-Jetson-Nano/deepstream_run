# Install DeepStream 6.0.1 for Jetson

## Install Dependencies

```bash
sudo apt install \
libssl1.0.0 \
libgstreamer1.0-0 \
gstreamer1.0-tools \
gstreamer1.0-plugins-good \
gstreamer1.0-plugins-bad \
gstreamer1.0-plugins-ugly \
gstreamer1.0-libav \
libgstrtspserver-1.0-0 \
libjansson4=2.11-1
```

## Install librdkafka (to enable Kafka protocol adaptor for message broker)

1.Clone the librdkafka repository from GitHub:
```bash
git clone https://github.com/edenhill/librdkafka.git
```

2.Configure and build the library:
```bash
cd librdkafka
git reset --hard 7101c2310341ab3f4675fc565f64f0967e135a6a
./configure
make
sudo make install
```

3.Copy the generated libraries to the deepstream directory:
```bash
sudo mkdir -p /opt/nvidia/deepstream/deepstream-6.0/lib
sudo cp /usr/local/lib/librdkafka* /opt/nvidia/deepstream/deepstream-6.0/lib
```

## Install the DeepStream SDK

1. Download deepstream-6.0.1 \
https://developer.nvidia.com/deepstream_sdk_v6.0.1_jetson.tbz2

2.Enter the following commands to extract and install the DeepStream SDK:

```bash
cd ~/Downloads
sudo tar -xvf deepstream_sdk_v6.0.1_jetson.tbz2 -C /
cd /opt/nvidia/deepstream/deepstream-6.0
sudo ./install.sh
sudo ldconfig
```
