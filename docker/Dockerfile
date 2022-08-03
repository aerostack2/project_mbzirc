# Ubuntu 20.04 with nvidia-docker2 beta opengl support
FROM osrf/mbzirc:mbzirc_models_latest

USER root

ARG DEBIAN_FRONTEND=noninteractive

## DEPENDENCIES

COPY docker/entrypoint.bash ./
ENTRYPOINT ["./entrypoint.bash"]