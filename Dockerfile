FROM tensorflow/tensorflow:latest-gpu

RUN pip3 install ai-benchmark

RUN pip3 install --force-reinstall -v "numpy==1.23.4"

RUN <<EOR
cat << 'EOF' >> main.py
from ai_benchmark import AIBenchmark
results = AIBenchmark().run()
EOF
EOR

CMD ["python3", "main.py"]
