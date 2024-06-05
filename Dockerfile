# use python2 interpreter here. With some minor changes,
# we can use python3.
FROM ubuntu:bionic
FROM python:3.8
COPY . /bin

# import needed python source files
ADD bin/Misc.py /
ADD bin/ImageClassification.py /
ADD bin/TrainingImagery.py /
ADD bin/TrainingPoints.py /
ADD bin/VegetationClassification.py /

# Update base container install
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y apt-utils

# Install GDAL dependencies
RUN apt-get install gdal-bin -y
RUN apt-get install -y python3-pip libgdal-dev locales

# Ensure locales configured correctly
RUN locale-gen en_US.UTF-8
ENV LC_ALL='en_US.utf8'

# Set python aliases for python3
RUN echo 'alias python=python3' >> ~/.bashrc
RUN echo 'alias pip=pip3' >> ~/.bashrc

# Update C env vars so compiler can find gdal
ENV CPLUS_INCLUDE_PATH=/usr/include/gdal
ENV C_INCLUDE_PATH=/usr/include/gdal

# This will install latest version of GDAL
RUN apt-get install proj-bin -y
RUN pip3 install setuptools 
RUN pip3 install numpy ==1.21.0
RUN pip3 install scipy ==1.7.2
RUN pip3 install pyproj ==3.1.0
RUN pip3 install pandas ==1.3.4
RUN pip3 install pyshp
RUN pip3 install matplotlib ==3.4.0
RUN pip3 install scikit-learn ==0.24.2
RUN pip3 install GDAL==2.2.3
RUN apt-get install -y python-gdal
ENTRYPOINT [ "python3", "VegetationClassification.py" ]
