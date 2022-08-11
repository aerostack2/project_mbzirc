# BUILD

```
docker build -f docker/Dockerfile -t skyeye-team:latest .
```

# RUN
```
docker run skyeye-team
```

# DEBUG
```
docker run -it --entrypoint bash skyeye-team
```

# SUBMITING
```
./mbzirc_submit.bash sky-eye skyeye-team <tag> <upstream_tag> <config_file>
```