FROM jupyter/datascience-notebook:lab-3.0.5

RUN jupyter labextension install jupyterlab-plotly

RUN pip install boto3 plotly chart_studio jupyter-require

# Install gophernotes 
ENV GOPATH /home/jovyan/go
ENV PATH $PATH:/usr/local/go/bin:${GOPATH}/bin
USER root

RUN curl -sfLO https://golang.org/dl/go1.16.7.linux-amd64.tar.gz \
  && tar -C /usr/local -xzf go1.16.7.linux-amd64.tar.gz \
  && rm -rf go go1.16.7.linux-amd64.tar.gz

USER jovyan

RUN mkdir -p $GOPATH \
  && env GO111MODULE=on /usr/local/go/bin/go get github.com/gopherdata/gophernotes \
  && mkdir -p /home/jovyan/.local/share/jupyter/kernels/gophernotes \
  && cd /home/jovyan/.local/share/jupyter/kernels/gophernotes \
  && cp "$(go env GOPATH)"/pkg/mod/github.com/gopherdata/gophernotes@v0.7.3/kernel/* "." \
  && chmod +w ./kernel.json # in case copied kernel.json has no write permission \
  && sed "s|gophernotes|/home/jovyan/go/bin/gophernotes|" < kernel.json.in > kernel.json
