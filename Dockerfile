# 使用Ubuntu 18.04作为基础镜像
FROM ubuntu:bionic

# 安装Python 3.8
FROM python:3.8

# 将代码复制到容器中
COPY . /bin

# 导入需要的Python源文件
ADD bin/Misc.py /
ADD bin/ImageClassification.py /
ADD bin/TrainingImagery.py /
ADD bin/TrainingPoints.py /
ADD bin/VegetationClassification.py /

# 更新基础容器并安装必要的工具和依赖
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y apt-utils wget

# 下载并安装指定版本的GDAL二进制包
RUN wget http://archive.ubuntu.com/ubuntu/pool/universe/g/gdal/gdal-bin_2.2.3+dfsg-2_amd64.deb && \
    apt-get install -y ./gdal-bin_2.2.3+dfsg-2_amd64.deb

# 安装GDAL开发库和其他必要的库
RUN apt-get install -y libgdal-dev locales

# 配置locale
RUN locale-gen en_US.UTF-8
ENV LC_ALL='en_US.utf8'

# 设置Python别名，确保文件不存在时创建符号链接
RUN ln -sf /usr/bin/python3 /usr/bin/python
RUN ln -sf /usr/bin/pip3 /usr/bin/pip

# 更新编译器的环境变量以找到GDAL
ENV CPLUS_INCLUDE_PATH=/usr/include/gdal
ENV C_INCLUDE_PATH=/usr/include/gdal

# 安装其他Python依赖
RUN pip install setuptools
RUN pip install numpy
RUN pip install scipy
RUN pip install pyproj
RUN pip install pandas
RUN pip install pyshp
RUN pip install matplotlib
RUN pip install scikit-learn

# 安装特定版本的GDAL Python包
RUN pip install GDAL==2.2.3

# 安装python-gdal
RUN apt-get install -y python-gdal

# 设置容器入口点
ENTRYPOINT ["python", "VegetationClassification.py"]
