#!/usr/bin/env bash
# wyoming-openwakeword
set -euxo pipefail

apt-get update
apt-get install -y --no-install-recommends \
   netcat-traditional \
   libopenblas0
apt-get clean
rm -rf /var/lib/apt/lists/*

pip3 install --no-cache-dir -U \
   setuptools \
   wheel
   
echo "wyoming-openwakeword: ${WYOMING_OPENWAKEWORD_VERSION}"

wget https://github.com/rhasspy/wyoming-openwakeword/archive/refs/tags/v${WYOMING_OPENWAKEWORD_VERSION}.tar.gz
tar xvf v${WYOMING_OPENWAKEWORD_VERSION}.tar.gz
cd  wyoming-openwakeword-${WYOMING_OPENWAKEWORD_VERSION}
sed -i 's|tflite-runtime-nightly|tflite-runtime @ https://github.com/feranick/TFlite-builds/releases/download/v.2.16.1/tflite_runtime-2.16.1-cp311-cp311-linux_aarch64.whl|' requirements.txt
cd ..
# TODO: This still uses tflite on CPU / Need to build from scratch on onnxruntime-gpu
pip3 install --no-cache-dir \
   --extra-index-url https://www.piwheels.org/simple \
   wyoming-openwakeword-${WYOMING_OPENWAKEWORD_VERSION}/


python3 -c 'import wyoming_openwakeword; print(wyoming_openwakeword.__version__);'
