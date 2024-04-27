xhost +local:root
docker run -u openfoam -it \
    -p 2222:22 \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v ~/src/foam:/home/openfoam/src/foam \
    openfoam \
    tilix
xhost -local:root
