FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu20.04

RUN apt-get update
RUN apt-get install -y python3 
RUN apt-get install -y python3-pip
RUN apt-get install -y tensorrt 
RUN apt-get install python3-libnvinfer-dev

RUN pip3 install tensorflow[and-cuda]
RUN pip3 install ai-benchmark
RUN pip3 install --force-reinstall -v "numpy==1.23.4"

RUN <<EOR
cat << 'EOF' >> main.py
from ai_benchmark import AIBenchmark
results = AIBenchmark().run()
EOF
EOR

CMD ["python3", "main.py"]
