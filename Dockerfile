FROM behren/machina-base-ubuntu:latest

RUN apt update &&\
    apt install -y openjdk-17-jdk openjdk-17-jre

# make a projects directory
RUN mkdir /machina/projects

# make a directory for 3rd party scripts
RUN mkdir /machina/ghidra_scripts

# install Ghidra to /machina/ghidra
RUN wget https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_11.0_build/ghidra_11.0_PUBLIC_20231222.zip -P /machina && \
    cd /machina &&\
    unzip ghidra_11.0_PUBLIC_20231222.zip &&\
    mv ghidra_11.0_PUBLIC ghidra

ENV GHIDRA_HOME=/machina/ghidra
ENV GHIDRA_SCRIPTS=/machina/ghidra_scripts
ENV USER_HOME=/machina

# patch analyzeHeadless to allow for configuring MAXMEM via env var
# default to 2G if not specified
RUN sed -i 's/MAXMEM=2G/MAXMEM=${GHIDRA_MAXMEM:-2G}/' /machina/ghidra/support/analyzeHeadless