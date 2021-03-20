FROM perl:5.32.1

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install git
RUN apt-get install python3

RUN apt-get install cpanminus build-essential libfile-copy-recursive-perl libxml-parser-perl fpc -y


RUN mkdir /app
WORKDIR /app

COPY . /app

RUN cpanm --installdeps .
RUN perl install.pl
ENV PATH "$PATH:/app/cmd/"
CMD j.sh
