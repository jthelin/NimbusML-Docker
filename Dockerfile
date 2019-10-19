## Build with command [from repo root directory]:
# docker build --tag jthelin/nimbusml . --file ./Dockerfile
##
## Run with command:
# docker run --rm -it jthelin/nimbusml bash
##

# Based on:
# https://docs.microsoft.com/en-us/nimbusml/installationguide

FROM nvidia/cuda:10.1-cudnn7-devel

# Install extra package dependencies.
RUN apt-get update --quiet \
 && apt-get install --yes --no-install-recommends --quiet \
        curl \
        libcurl4 \
        vim-tiny \
        python3 \
        python3-pip \
        python3-setuptools \
        python3-dev \
 && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/python3 /usr/local/bin/python \
 && ln -s /usr/bin/pip3 /usr/local/bin/pip

RUN command -v python && command -v pip && python --version
RUN pip install --no-cache-dir --upgrade pip setuptools

# Install extra python package dependencies.
RUN pip install distro dotnetcore2 numpy pandas pytz python-dateutil scikit-learn scipy six

# Install MimbusML python package.
RUN pip install nimbusml

# Set the working directory
RUN mkdir -p /datadrive && mkdir -p /home/app/src
VOLUME /datadrive
WORKDIR /home/app/src

# Run a simple smoke test to config our setup works ok
CMD [ "python", "-m", "nimbusml.examples.FastLinearClassifier" ]

