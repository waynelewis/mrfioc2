import os
import time
os.system("./load_modules.sh")
os.system("screen -d -m -S IOCScreen ./st_embla_28Hz.cmd")
time.sleep(3)
os.system("./configure_sequence_embla_28Hz.sh")
