FROM mambaorg/micromamba:latest
LABEL Description="EsMeCaTa docker image"

ARG MAMBA_DOCKERFILE_ACTIVATE=1

RUN micromamba install git nextflow mmseqs2 pandas sparqlwrapper requests biopython eggnog-mapper pip lxml bioservices gcc pronto orsum gseapy plotly pyhmmer=0.11.0 -c conda-forge -c bioconda
#nextflow mmseqs2 pandas sparqlwrapper requests biopython eggnog-mapper wget

RUN cd /home/mambauser ;\
    mkdir programs;\
    cd programs

RUN cd /home/mambauser/programs;\
    git clone https://github.com/AuReMe/esmecata.git ;\
    git clone https://github.com/ArnaudBelcour/tabigecy.git ;\
    git clone https://github.com/ArnaudBelcour/bigecyhmm.git

RUN cd /home/mambauser/programs;\
    cd esmecata ;\
    pip install -e . ;\
    cd ../bigecyhmm ;\
    pip install -e .;\
    cd ..

RUN pip install arakawa

RUN cd /home/mambauser/programs;\
    wget https://zenodo.org/records/13354073/files/esmecata_database.zip;\
    wget https://zenodo.org/records/13354073/files/taxdmp_2024-10-01.tar.gz

RUN cd /home/mambauser/programs;\
    python3 -c "from ete4 import NCBITaxa; ncbi = NCBITaxa(taxdump_file='taxdmp_2024-10-01.tar.gz')"


