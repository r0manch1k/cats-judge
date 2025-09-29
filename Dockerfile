FROM freepascal/fpc:3.2.2-bookworm-full

RUN apt update
RUN apt install -y git
RUN apt install -y python3 python3-venv python3-numpy python3-scipy
RUN apt install -y build-essential \
        cpanminus \
        libfile-copy-recursive-perl \
        libxml-parser-perl \
        libpq-dev \
        unzip \
    vim mc
    
WORKDIR /app

COPY . .
ENV comspec="/bin/bash"

WORKDIR /app/cmd/
RUN wget https://github.com/r0manch1k/spawner2-cgroups2/releases/download/v0.0.1/sp.zip
RUN unzip sp.zip
RUN rm sp.zip

WORKDIR /app

RUN chmod +x /app/cmd/sp
RUN chmod +x /app/cmd/create_cgroups.sh
ENV PATH="$PATH:/app/cmd/"

RUN cpanm --notest --installdeps .
RUN perl install.pl
RUN git init
RUN git config --global user.name "Your Name"
RUN git config --global user.email "your.email@example.com"
RUN git add README.md
RUN git commit -m 'init'

CMD ["j.sh", "serve"]
