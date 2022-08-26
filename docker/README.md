# BUILD

```
docker build -f docker/Dockerfile -t skyeye-team:latest .
```


> When the container is succesfully build we follow: https://github.com/osrf/mbzirc/wiki/Simulation-setup-using-Docker-Compose for recreating the system.

> [Troubleshoot] If errors in rendering happens try ```$ xhost +``` before launching the compose system

# RUN
```
docker run skyeye-team
```

# DEBUG
```
docker run -it --entrypoint bash skyeye-team
# TEST WITH GPU
docker run --runtime=nvidia -it --gpus all --network host --entrypoint /bin/bash skyeye-team
```

# SUBMITING
```
./mbzirc_submit.bash sky-eye skyeye-team <tag> <upstream_tag> <config_file>
```

# LOGS
```
aws s3 sync s3://cloudsim-mbzirc-logs/sky-eye/ logs
```
