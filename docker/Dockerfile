# Ubuntu 20.04 with nvidia-docker2 beta opengl support
FROM osrf/mbzirc:mbzirc_models_latest

USER root

ARG DEBIAN_FRONTEND=noninteractive

# Tools useful during development
RUN apt-get update -qq \
    && apt-get install --no-install-recommends -y -qq \
    build-essential \
    atop \
    cmake \
    cppcheck \
    expect \
    gdb \
    git \
    gnutls-bin \
    libbluetooth-dev \
    libccd-dev \
    libcwiid-dev \
    libfcl-dev \
    libgoogle-glog-dev \
    libspnav-dev \
    libusb-dev \
    python3-dbg \
    python3-empy \
    python3-numpy \
    python3-setuptools \
    python3-pip \
    python3-venv \
    software-properties-common \
    vim \
    net-tools \
    iputils-ping \
    xvfb \
    curl \
    && apt-get clean -qq

# set up ros2 repo
RUN /bin/sh -c 'curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg' \
    && /bin/sh -c 'echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null'

# install ignition fortress
RUN apt-get update \
    && apt-get install -y ignition-fortress \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean -qq

# install rosdep
RUN apt-get update \
    && apt install -y python3-rosdep \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean -qq
RUN rosdep init \
    && rosdep update

# install ROS2
RUN apt-get update \
    && apt-get install -y ros-galactic-ros-base \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean -qq

# install colcon
RUN apt-get -qq update && apt-get -q -y install \
    python3-vcstool \
    python3-colcon-common-extensions \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get -qq clean

# install AS2 core dependencies (WIP)
RUN apt-get update && \
    apt-get install -y \
    tmux \
    libyaml-cpp* \
    libeigen3-dev \
    python3-pip \
    python3-testresources \
    ros-galactic-ament-cmake-clang-format \
    ros-galactic-eigen3-cmake-module \
    ros-galactic-gazebo-ros-pkgs \
    ros-galactic-geographic-msgs \
    libgeographic-dev \
    geographiclib-tools \
    libgoogle-glog* \
    libgflags* \
    libnlopt-cxx-dev \
    ros-galactic-behaviortree-cpp-v3 \
    ros-galactic-nav2-behavior-tree \
    ros-galactic-nav2-msgs \
    ros-galactic-ros-ign-bridge \
    ros-galactic-ros-ign-gazebo \
    ros-galactic-vision-msgs \
    ros-galactic-radar-msgs \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# sudo ln -s /usr/share/cmake/geographiclib/FindGeographicLib.cmake /usr/share/cmake-*/Modules/ &&\
# sudo pip3 install -U empy pyros-genmsg setuptools jinja2

# area2path --> Fields2Cover
RUN add-apt-repository -y ppa:ubuntugis/ppa
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        cmake \
        doxygen \
        g++ \
        git \
        libeigen3-dev \
        libgdal-dev \
        libpython3-dev \ 
        python3 \
        python3-pip \
        python3-matplotlib \
        lcov \
        libgtest-dev \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean
RUN python3 -m pip install gcovr

# mbzirc_loc --> Ceres
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        cmake \
        libgoogle-glog-dev \
        libgflags-dev \
        libeigen3-dev \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Use ATLAS for BLAS & LAPACK
# RUN apt-get install libatlas-base-dev
# SuiteSparse (optional)
# RUN apt-get install libsuitesparse-dev

RUN curl http://ceres-solver.org/ceres-solver-2.1.0.tar.gz --output ceres-solver-2.1.0.tar.gz && \
    tar zxf ceres-solver-2.1.0.tar.gz
RUN mkdir ceres-bin && \
    cd ceres-bin && \
    cmake ../ceres-solver-2.1.0
RUN cd ceres-bin && \
    make -j3
# make test
# # Optionally install Ceres, it can also be exported using CMake which
# # allows Ceres to be used without requiring installation, see the documentation
# # for the EXPORT_BUILD_DIR option for more information.
RUN cd ceres-bin && \
    make install

# YOLO_OBJECT_DETECTOR --> DARKNET_VENDOR --> CUDA
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        nvidia-cuda-toolkit \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# RUN add-apt-repository ppa:graphics-drivers \
#     && apt-key del 7fa2af80 \
#     && apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/3bf863cc.pub \
#     && bash -c 'echo "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list' \
#     && apt update && apt install cuda-11-5  -y \
#     && rm -rf /var/lib/apt/lists/* \
#     && apt-get clean

# Commands below run as the developer user
USER $USERNAME

# When running a container start in the developer's home folder
WORKDIR /home/$USERNAME

## TODO: needed? Installation scripts are not launched directly and as2 utils not used...
# install aerostack2
RUN mkdir -p /home/${USERNAME}/aerostack2_ws/src/mbzirc
RUN cd /home/$USERNAME/aerostack2_ws/src \
    && git clone https://github.com/aerostack2-developers/aerostack2.git

ENV AEROSTACK2_PATH /home/$USERNAME/aerostack2_ws/src/aerostack2
ENV AEROSTACK2_WORKSPACE /home/$USERNAME/aerostack2_ws
ENV AEROSTACK2_PROJECTS /home/$USERNAME/aerostack2_ws/src/aerostack2/projects        
ENV AEROSTACK2_SIMULATION_DRONE_ID drone_sim_0
ENV IGNITION_VERSION fortress

## TODO: needed?
ENV PATH $PATH:$AEROSTACK2_PATH/scripts/
RUN echo 'alias as2="source $AEROSTACK2_PATH/scripts/as2.bash"' >> ~/.bashrc    
RUN echo 'source $AEROSTACK2_PATH/scripts/bash_utils/as2_autocompletion.bash' >> ~/.bashrc    

WORKDIR /home/$USERNAME/aerostack2_ws/src/aerostack2
COPY install.repos.secret ./install.repos
RUN vcs import --recursive < ./install.repos && echo "imported"
RUN rm install.repos

# RUN as2 build
WORKDIR /home/${USERNAME}/aerostack2_ws

RUN /bin/bash -c 'source /opt/ros/galactic/setup.bash \
    && colcon build --symlink-install && echo "Build successfully "'

RUN /bin/sh -c 'echo ". /opt/ros/galactic/setup.bash" >> ~/.bashrc ' \
    && /bin/sh -c 'echo ". ~/aerostack2_ws/install/setup.bash" >> ~/.bashrc'

# MBZIRC PROJECT
WORKDIR /home/${USERNAME}/aerostack2_ws/src/aerostack2/projects/project_mbzirc
COPY . .

COPY docker/entrypoint_tmux.bash ./entrypoint.bash
RUN sudo rm install.repos.secret
ENTRYPOINT ["./entrypoint.bash"]

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/cuda-10.1/compat/

