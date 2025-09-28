FROM freepascal/fpc:3.2.2-bookworm-full

RUN apt update
RUN apt install -y git
RUN apt install -y python3 python3-venv
RUN apt install -y build-essential \
        cpanminus \
        libfile-copy-recursive-perl \
        libxml-parser-perl \
        libpq-dev \
        unzip
    
WORKDIR /app

COPY . .
# Create a virtual environment
ENV VIRTUAL_ENV=/app/venv
RUN python3 -m venv $VIRTUAL_ENV

# Add the virtual environment's bin directory to the PATH
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN pip install -r requirements.txt
COPY dockerfiles/judge/local.xml.template local.xml.template
COPY dockerfiles/judge/Config.pm.template Config.pm.template
RUN $VIRTUAL_ENV/bin/python render.py
RUN rm -rf venv
RUN rm render.py requirements.txt


RUN cp local.xml /app/config/local.xml
RUN cp Config.pm /app/lib/cats-problem/CATS/Config.pm

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

CMD ["j.sh", "serve"]
