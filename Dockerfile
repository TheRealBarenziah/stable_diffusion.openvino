FROM openvino/ubuntu20_runtime:2022.1.0_20210416

# yolo
USER root

# Prepare to build python3.8 from source
RUN apt-get update && \ 
	apt-get install -y apt-utils \
	git \
	build-essential \
	zlib1g-dev \
	libncurses5-dev \
	libgdbm-dev \
	libnss3-dev \
	libssl-dev \
	libreadline-dev \
	libffi-dev \ 
	libsqlite3-dev \
	wget \
	libbz2-dev \
	&& apt-get upgrade -y

RUN wget https://www.python.org/ftp/python/3.8.0/Python-3.8.0.tgz

RUN tar -xf Python-3.8.0.tgz && cd Python-3.8.0

WORKDIR /opt/intel/openvino_2022.1.0.643/Python-3.8.0

# The --enable-optimizations option optimizes the Python binary by running multiple tests. This makes the build process slower.
RUN ./configure --enable-optimizations

# For faster build time, modify the -j to correspond to the number of cores in your processor. You can find the number by typing nproc.
RUN make -j 4

RUN make altinstall

RUN python3.8 --version

WORKDIR /opt/intel/openvino_2022.1.0.643
RUN mkdir /app
WORKDIR /app
COPY ./ ./

# https://github.com/bes-dev/stable_diffusion.openvino/blob/master/README.md#install-requirementsRUN pip install -r requirements.txt
RUN python3.8 -m pip install -r requirements.txt

RUN python3.8 stable_diffusion.py --prompt "Street-art painting of Emilia Clarke in style of Banksy, photorealism"

RUN echo "ls  : "
CMD ls

