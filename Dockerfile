FROM ubuntu:latest
LABEL Description="EsMeCaTa docker image"

# Install dependencies
RUN apt-get update && apt-get install -y \
    python3-pip \
    git \
    openjdk-21-jdk \
    wget \
    curl \
    libnss3 \
    libatk-bridge2.0-0 \
    libcups2 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libxkbcommon0 \
    libpango-1.0-0 \
    libcairo2 \
    libasound2

# Install brew
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"

# Install mmseqs2
RUN brew install mmseqs2

# Install all python dependencies with pip
RUN pip install pip --upgrade
RUN pip install pandas sparqlwrapper requests biopython eggnog-mapper biopython bioservices arakawa gseapy plotly kaleido ontosunburst pronto seaborn networkx

# Install Google Chrome for plotly
RUN plotly_get_chrome -y

# Create programs folder
RUN mkdir /programs;\
    mkdir /programs/bin

# Install nextflow
RUN curl -s https://get.nextflow.io | bash ;\
    chmod +x nextflow ;\
    mv nextflow /programs/bin

# Clone esmecata, tabigecy and orsum
RUN cd /programs;\
    git clone https://github.com/AuReMe/esmecata.git ;\
    git clone https://github.com/ArnaudBelcour/tabigecy.git ;\
    git clone https://github.com/ArnaudBelcour/bigecyhmm.git ;\
    git clone https://github.com/ozanozisik/orsum.git ;\
    cd orsum ;\
    chmod +x orsum.py;\
    cp *.py /programs/bin

# Add all binaries (nextflow, orsum) to path
ENV PATH="/programs/bin/:${PATH}"

# Install esmecata and bigecyhmm
RUN cd programs;\
    cd esmecata ;\
    pip install -e . ;\
    cd ../bigecyhmm ;\
    pip install -e .

# Install version of pyhmmer to avoid issue with bigecyhmm 0.1.8
RUN pip install pyhmmer==0.11.1

# Download esmecata precomputed database and NCBI taxonomy database
RUN cd /programs;\
    wget https://zenodo.org/records/13354073/files/esmecata_database.zip;\
    wget https://zenodo.org/records/13354073/files/taxdmp_2024-10-01.tar.gz

# Preload NCBI Taxonomy database in ete4
RUN cd /programs;\
    python3 -c "from ete4 import NCBITaxa; ncbi = NCBITaxa(taxdump_file='taxdmp_2024-10-01.tar.gz')"


