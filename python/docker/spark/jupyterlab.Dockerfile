FROM cluster-base

# -- Layer: JupyterLab

ARG spark_version=3.3.1
ARG jupyterlab_version=3.6.1

# Install dependencies
RUN apt-get update -y --fix-missing && \
    apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv \
    openjdk-11-jre-headless && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create and activate a virtual environment
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --no-cache-dir \
    pyspark==${spark_version} \
    jupyterlab==${jupyterlab_version}

# Ensure the virtual environment is used by default
ENV PATH="/opt/venv/bin:$PATH"

# -- Runtime

EXPOSE 8888
WORKDIR ${SHARED_WORKSPACE}
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token="]