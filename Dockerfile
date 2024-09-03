FROM tensorflow/tensorflow:devel-gpu

RUN pip3 install tensorflow
RUN pip3 install ai-benchmark

RUN <<EOR
cat << 'EOF' >> main.py
from ai_benchmark import AIBenchmark
results = AIBenchmark().run()
EOF
EOR

CMD ["python3", "main.py"]
