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
  && apt-get clean -qq \
  && rosdep init \
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

# Commands below run as the developer user
USER $USERNAME

# When running a container start in the developer's home folder
WORKDIR /home/$USERNAME

# install aerostack2
RUN mkdir -p /home/${USERNAME}/aerostack2_ws/src

RUN cd /home/$USERNAME/aerostack2_ws/src \
    && git clone https://github.com/aerostack2-developers/aerostack2.git

#################### TODO
# install core dependencies (WIP)
# sudo apt update
# # utils
# sudo apt install tmux python3-vcstool -y

# # libs
# sudo apt install libyaml-cpp* -y &&\
# sudo apt install libeigen3-dev -y

# # python dependencies
# sudo apt install python3-pip python3-testresources -y && \
# sudo apt install python3-colcon-common-extensions -y

# # ros2 dependencies

# sudo apt install ros-${ROS_DISTRO}-ament-cmake-clang-format -y &&\
# sudo apt install ros-${ROS_DISTRO}-eigen3-cmake-module -y &&\
# sudo apt install ros-${ROS_DISTRO}-gazebo-ros-pkgs -y &&\
# sudo apt install ros-${ROS_DISTRO}-geographic-msgs -y

# # geographic lib
# sudo apt install libgeographic-dev geographiclib-tools -y &&\
# sudo ln -s /usr/share/cmake/geographiclib/FindGeographicLib.cmake /usr/share/cmake-*/Modules/ &&\
# sudo pip3 install -U empy pyros-genmsg setuptools jinja2

# # libgoogle utils

# sudo apt install libgoogle-glog* -y &&\
# sudo apt install libgflags* -y &&\
# sudo apt install libnlopt-cxx-dev -y

# # USB Drivers
# sudo usermod -a -G dialout $USER &&\
# sudo apt-get remove modemmanager -y &&\
# sudo apt install gstreamer1.0-plugins-bad gstreamer1.0-libav gstreamer1.0-gl -y &&\
# sudo udevadm control --reload-rules && udevadm trigger

ENV AEROSTACK2_PATH /home/$USERNAME/aerostack2_ws/src/aerostack2
ENV AEROSTACK2_WORKSPACE /home/$USERNAME/aerostack2_ws
ENV AEROSTACK2_PROJECTS /home/$USERNAME/aerostack2_ws/src/aerostack2/projects
# ENV PATH $PATH:$AEROSTACK2_PATH/scripts/
        
ENV AEROSTACK2_SIMULATION_DRONE_ID drone_sim_0
        
# RUN alias as2="source $AEROSTACK2_PATH/scripts/as2.bash"
# enable custom AS2 bash completions
# source $AEROSTACK2_PATH/scripts/bash_utils/as2_autocompletion.bash

###################### TODO
# Release instalation (WIP)

#############################3
# # Prepare the colcon workspace
# RUN mkdir -p mbzirc_ws/src

# # clone ros_ign bridge
# RUN cd /home/$USERNAME/mbzirc_ws/src \
#  && git clone https://github.com/osrf/ros_ign.git -b galactic

# WORKDIR /home/$USERNAME/mbzirc_ws

# COPY . src/mbzirc

# ENV IGNITION_VERSION fortress

# RUN sudo apt-get update \
#   && rosdep update \
#   && rosdep install -r --from-paths src -i -y --rosdistro galactic \
#   && sudo rm -rf /var/lib/apt/lists/* \
#   && sudo apt-get clean -qq

# # build mbzirc_seed
# RUN /bin/bash -c 'source /opt/ros/galactic/setup.bash \
#   && colcon build --merge-install --packages-select ros_ign_interfaces mbzirc_seed'

# RUN /bin/sh -c 'echo ". /opt/ros/galactic/setup.bash" >> ~/.bashrc' \
#  && /bin/sh -c 'echo ". ~/mbzirc_ws/install/setup.sh" >> ~/.bashrc'

COPY docker/entrypoint.bash ./
ENTRYPOINT ["./entrypoint.bash"]