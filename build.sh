# build the image
docker build -t deepstream:jetson --build-arg L4T_VERSION="r32.6" .