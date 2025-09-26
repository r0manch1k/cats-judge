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
COPY dockerfiles/judge/local.xml /app/config/local.xml
COPY dockerfiles/judge/Config.pm /app/lib/cats-problem/CATS/Config.pm

RUN cpanm --notest --installdeps .
ENV comspec="/bin/bash"

RUN perl install.pl


WORKDIR /app/cmd/
RUN wget https://github.com/r0manch1k/spawner2-cgroups2/releases/download/v0.0.1/sp.zip
RUN unzip sp.zip
RUN rm sp.zip

RUN chmod +x /app/cmd/sp
RUN chmod +x /app/cmd/create_cgroups.sh
ENV PATH="$PATH:/app/cmd/"

CMD ["j.sh", "serve"]
