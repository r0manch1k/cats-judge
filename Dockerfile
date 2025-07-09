FROM freepascal/fpc:latest-buster-full

RUN apt update
RUN apt install -y git
RUN apt install -y python3
RUN apt install -y build-essential \
        cpanminus \
        libfile-copy-recursive-perl \
        libxml-parser-perl \
        libpq-dev \
        unzip
    
WORKDIR /app

COPY . .
RUN cpanm --notest --installdeps .
COPY dockerfiles/judge/Config.pm /app/lib/cats-problem/CATS/Config.pm
ENV comspec="/bin/bash"

RUN perl install.pl

COPY dockerfiles/judge/local.xml /app/config/local.xml

RUN rm -rf Spawner && mkdir Spawner

WORKDIR /app/Spawner
RUN wget https://github.com/r0manch1k/spawner2-cgroups2/releases/download/v0.0.1/sp.zip
RUN unzip sp.zip
WORKDIR /app

RUN mkdir -p /app/spawner-bin/linux-i386
RUN cp /app/Spawner/sp /app/spawner-bin/linux-i386/sp
RUN cp /app/Spawner/create_cgroups.sh /app/cmd/create_cgroups.sh
RUN chmod +x /app/spawner-bin/linux-i386/sp
RUN chmod +x /app/cmd/create_cgroups.sh
ENV PATH="/app/cmd/:${PATH}"

CMD ["j.sh", "serve"]
