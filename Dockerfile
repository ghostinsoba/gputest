FROM nvidia/cuda:12.1.1-runtime-ubuntu20.04

RUN apt-get update && apt-get install -y python3-pip python3-dev

RUN <<EOR
cat << 'EOF' >> requirements.txt
numba==0.58.1
numpy==1.24.4
EOF
EOR

RUN <<EOR
cat << 'EOF' >> main.py
from numba import jit, cuda 
import numpy as np 

from timeit import default_timer as timer
import time    
  
# normal function to run on cpu 
def func(a):                                 
    for i in range(10000000): 
        a[i]+= 1      
  
# function optimized to run on gpu  
@jit(target_backend='cuda')                          
def func2(a): 
    for i in range(10000000): 
        a[i]+= 1

def calc():
    n = 10000000                            
    a = np.ones(n, dtype = np.float64) 
      
    start = timer() 
    func(a) 
    print("without GPU:", timer()-start)     
      
    start = timer() 
    func2(a) 
    print("with GPU:", timer()-start) 


if __name__=="__main__": 
    while True:
        calc()
        time.sleep(60)
EOF
EOR


RUN pip install --no-cache-dir -r requirements.txt

CMD ["python3", "main.py"]
