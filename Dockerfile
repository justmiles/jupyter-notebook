FROM jupyter/datascience-notebook:lab-3.0.5

RUN jupyter labextension install jupyterlab-plotly

RUN pip install boto3 plotly chart_studio jupyter-require