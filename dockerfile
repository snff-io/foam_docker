# Use the official OpenFOAM image as the base
FROM openfoam/openfoam8-paraview56

# Set the user to root for installation purposes
USER root

# Update the package list
RUN apt-get update

# Install sudo for elevated privileges and X11 apps for GUI support
RUN apt-get install -y --no-install-recommends \
    sudo \
    x11-apps \
    x11-xserver-utils \
    dbus-x11 \
    libxext-dev \
    libxrender1 \
    libxtst6 \
    libfreetype6 \
    libfontconfig1

RUN apt-get update && apt-get install -y --no-install-recommends \
    libqt5x11extras5 \
    qtbase5-dev \
    qtchooser \
    qt5-qmake \
    qtbase5-dev-tools \
    tilix

#vscode
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
RUN install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft-archive-keyring.gpg
RUN sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
RUN apt-get update
RUN apt-get install -y code


# Install SSH server and utilities
RUN apt-get install -y openssh-server

run apt update -y
run apt upgrade -y

# Enable password authentication
RUN sed -i 's/^#PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Enable root login
RUN sed -i 's/^#PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config

# Add a non-root user 'foamuser' with sudo privileges
#RUN adduser --disabled-password --gecos '' openfoam 
RUN echo 'openfoam ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Switch to the new user
USER openfoam

# Set the working directory
WORKDIR /home/openfoam

ENV QT_X11_NO_MITSHM=1



# Expose the SSH port
EXPOSE 22

# Ensure SSH service starts on container start
CMD ["/usr/sbin/sshd", "-D"]

# As 'foamuser', run bash by default
#CMD ["/bin/bash"]
