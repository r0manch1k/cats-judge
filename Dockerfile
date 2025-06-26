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

# Might be wrong for different os
RUN cd dockerfiles/judge/fpc-3.2.2.x86_64-linux && ./install.sh

RUN cpanm --notest --installdeps .

COPY dockerfiles/judge/Config.pm /app/lib/cats-problem/CATS/Config.pm

ENV comspec "/bin/bash"

RUN perl install.pl

COPY dockerfiles/judge/local.xml /app/config/local.xml

RUN rm -rf Spawner && mkdir Spawner

RUN git clone https://github.com/r0manch1k/spawner2-cgroups2.git Spawner

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /app/Spawner

RUN cargo build --release

WORKDIR /app

# Might be wrong for different os
RUN mkdir -p /app/spawner-bin/linux-i386
RUN cp /app/Spawner/target/release/sp /app/spawner-bin/linux-i386/sp
RUN cp /app/Spawner/create_cgroups.sh /app/create_cgroups.sh
RUN chmod +x /app/spawner-bin/linux-i386/sp
RUN chmod +x /app/create_cgroups.sh
ENV PATH "$PATH:/app/cmd/"

CMD j.sh serve
