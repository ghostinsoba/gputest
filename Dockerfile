FROM python:3.8-slim as builder
RUN apt update && \
    apt install --no-install-recommends -y build-essential gcc

RUN pip3 install tensorflow
RUN pip3 install ai-benchmark
RUN pip3 install --force-reinstall -v "numpy==1.23.4"

# Stage 2: Runtime
FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu20.04

RUN apt update && \
    apt install --no-install-recommends -y build-essential software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt install --no-install-recommends -y python3.8 python3-distutils && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 1 && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 2 && \
    apt clean && rm -rf /var/lib/apt/lists/*
COPY --from=builder /root/.local/lib/python3.8/site-packages /usr/local/lib/python3.8/dist-packages

RUN <<EOR
cat << 'EOF' >> main.py
from ai_benchmark import AIBenchmark
results = AIBenchmark().run()
EOF
EOR

CMD ["python3", "main.py"]
