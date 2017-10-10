FROM jupyterhub/jupyterhub:0.7.2
MAINTAINER ome-devel@lists.openmicroscopy.org.uk

RUN pip install -U pip
RUN pip install dockerspawner==0.7.0
# TODO: Use upstream pypi release when it's updated
RUN pip install https://github.com/IDR/kubespawner/archive/0.5.2-IDR1.zip
RUN pip install https://github.com/IDR/oauthenticator/archive/0.5.1-IDR3.zip
RUN pip install jupyterhub-dummyauthenticator

# Display resource usage in notebooks https://github.com/yuvipanda/nbresuse
RUN conda install -qy psutil && \
    pip install git+https://github.com/yuvipanda/nbresuse.git@2ea06299e8c2564843a8692f17e1353233c01130 && \
    jupyter serverextension enable --py nbresuse && \
    jupyter nbextension install --py nbresuse && \
    jupyter nbextension enable --py nbresuse

ADD https://raw.githubusercontent.com/jupyterhub/jupyterhub/0.7.2/examples/cull-idle/cull_idle_servers.py /srv/jupyterhub/
ADD jupyterhub_config.py /srv/jupyterhub/

RUN useradd user
ADD run.sh /run.sh

ENTRYPOINT ["/run.sh"]
