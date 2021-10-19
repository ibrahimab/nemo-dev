# base image
FROM nvcr.io/nvidia/l4t-ml:r32.6.1-py3 AS nemo-deps

# setting up utf8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

# setting workdir
WORKDIR /nemo

# updating packages
RUN apt-get update &&\
	apt-get install apt-utils &&\
	apt-get upgrade -y 

# installing deps
RUN apt-get install -y \
	cmake \
	curl \
	pkg-config \
	protobuf-compiler \
	libprotoc-dev \
	python3-dev \
	python3-venv \
	libmecab-dev \
	mecab \
	build-essential \
	swig \
	ffmpeg \
	libsndfile1 \
	libasound2-dev \
	alsa-base \
	portaudio19-dev \
	libopencc-dev \
	unzip \
	vim \
	tzdata

# setting up locales
RUN dpkg-reconfigure locales

# installing rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# adding rust to PATH
ENV PATH="/root/.cargo/bin:${PATH}"

# check if rust is installed successfully
RUN rustc --version

# setup pip deps
RUN pip3 install setuptools-rust &&\
	pip3 install wheel

# install nemo
RUN pip3 install nemo_toolkit[asr]

RUN apt-get install -y \
	libboost-all-dev \
        zlib1g-dev \
        libbz2-dev \
        liblzma-dev

# install additional packages for ASR
RUN pip3 install plotly
RUN pip3 install ipywidgets

RUN apt-get install -y \
	libeigen3-dev \
	doxygen

COPY setup-deps.sh /tmp/setup-deps.sh
RUN ["chmod", "+x", "/tmp/setup-deps.sh"]
RUN /tmp/setup-deps.sh

ENV PYTHONIOENCODING=utf-8

RUN pip3 install nemo_toolkit[nlp]

RUN apt-get install -y \
	libjemalloc-dev \
	libboost-dev \
	libboost-filesystem-dev \
	libboost-system-dev \
	libboost-regex-dev \
	autoconf \
	flex \
	bison
