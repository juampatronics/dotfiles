# copy this file into your ~/.ipython/profile_default/startup folder
import numpy as np
from matplotlib import pyplot as plt
import matplotlib as mpl
import pandas as pd

print(f'np {np.__version__}')
print(f'pandas {pd.__version__}')
print(f'matplotlib {mpl.__version__}')

print('Automatically reload all modules...')
%load_ext autoreload
%autoreload 2
