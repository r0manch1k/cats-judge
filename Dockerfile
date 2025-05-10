FROM perl:5.32.1

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install git
RUN apt-get install python3

RUN apt-get install cpanminus build-essential libfile-copy-recursive-perl libxml-parser-perl -y

RUN mkdir /app

WORKDIR /app

COPY . /app

RUN cd dockerfiles/fpc-3.2.2.x86_64-linux && ./install.sh

RUN cpanm --notest --installdeps .

ENV comspec "/bin/bash"

COPY dockerfiles/Config.pm /app/lib/cats-problem/CATS/Config.pm

RUN perl install.pl

ENV PATH "$PATH:/app/cmd/"

CMD j.sh
