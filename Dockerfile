FROM jupyter/datascience-notebook:lab-3.6.2

RUN jupyter labextension install jupyterlab-plotly

RUN pip install boto3 plotly chart_studio jupyter-require

# Install gophernotes 
ENV GOPATH /home/jovyan/go
ENV PATH $PATH:/usr/local/go/bin:${GOPATH}/bin
USER root

USER jovyan

# Configure AWS Glue
RUN pip install sparkmagic "ipywidgets>=7.6" "jupyter-dash" jupyterlab-code-formatter black isort \
  && jupyter nbextension enable --py --sys-prefix widgetsnbextension \
  && jupyter labextension install @jupyter-widgets/jupyterlab-manager

USER root

RUN cd /opt/conda/lib/python3.1/site-packages \
  && jupyter-kernelspec install sparkmagic/kernels/sparkkernel \
  && jupyter-kernelspec install sparkmagic/kernels/pysparkkernel

USER jovyan

COPY --chown=jovyan:users sparkmagicconfig.json /home/jovyan/.sparkmagic/config.json

RUN mkdir -p /home/jovyan/.sparkmagic/logs

EXPOSE 8888

CMD ["jupyter", "notebook", "--port=8888", "--no-browser","--NotebookApp.token=''","--NotebookApp.password=''"]
