FROM perl:5.32.1

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install git
RUN apt-get install python3

RUN apt-get update && apt-get install -y \
    cpanminus \
    build-essential \
    libfile-copy-recursive-perl \
    libxml-parser-perl -y \
    && apt-get clean

WORKDIR /app

COPY . .

RUN cd dockerfiles/fpc-3.2.2.x86_64-linux && ./install.sh

RUN cpanm --notest --installdeps .

COPY dockerfiles/Config.pm /app/lib/cats-problem/CATS/Config.pm

ENV comspec "/bin/bash"

RUN perl install.pl

COPY dockerfiles/local.xml /app/config/local.xml

RUN rm -rf Spawner

RUN mkdir Spawner

RUN git clone https://github.com/r0manch1k/spawner2-cgroups2.git Spawner

WORKDIR /app/Spawner

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

ENV PATH="/root/.cargo/bin:${PATH}"

RUN cargo build --release

# RUN ./create_cgroups.sh

WORKDIR /app

RUN cp Spawner/target/release/sp Spawner/

ENV PATH "$PATH:/app/cmd/"

CMD j.sh serve
