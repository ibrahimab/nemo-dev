#!/usr/bin/env bash

mkdir -p /tmp/ctc-decoders
cd /tmp/ctc-decoders
git clone https://github.com/dusty-nv/OpenSeq2Seq -b ctc-decoders
cd OpenSeq2Seq/decoders

echo " CUR DIR: $(pwd) \n"

if [ ! -d kenlm ]; then
    git clone https://github.com/kpu/kenlm.git
    echo -e "\n"
fi

if [ ! -d kenlm/build ]; then
    mkdir kenlm/build
    cd kenlm/build
    cmake ..
    make
    cd ../..
    echo -e "\n"
fi

echo "\n KENLM built, cur dir: $(pwd) \n"

if [ ! -d openfst-1.6.3 ]; then
    echo "Download and extract openfst ..."
    wget http://www.openfst.org/twiki/pub/FST/FstDownload/openfst-1.6.3.tar.gz
    tar -xzvf openfst-1.6.3.tar.gz
    echo -e "\n"
fi

echo "\n openfst downloaded, cur dir: $(pwd)"

if [ ! -d ThreadPool ]; then
    git clone https://github.com/progschj/ThreadPool.git
    echo -e "\n"
fi

echo "\n threadpool cloned, cur dir: $(pwd)"

echo "Install decoders ..."
python3 setup.py install --num_processes 4

echo "Testing installation ..."
python3 ctc_decoders_test.py
