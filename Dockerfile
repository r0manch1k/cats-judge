FROM freepascal/fpc:latest-focal-full

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

# Create a virtual environment
ENV VIRTUAL_ENV=/app/venv
CMD [ "python", "-m", "venv", "$VIRTUAL_ENV"]

# Add the virtual environment's bin directory to the PATH
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN pip install -r requirements.txt
CMD ["python", "render.py"]
RUN rm -rf venv
RUN rm render.py requirements.txt


RUN cp dockerfiles/judge/local.xml /app/config/local.xml
RUN cp dockerfiles/judge/Config.pm /app/lib/cats-problem/CATS/Config.pm

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
