import os
name = os.path.basename(__file__).split(".py")[0]
import matplotlib.pyplot as plt
##########
import sys
import numpy as np
sys.path.append('.')
import ergodicity
#from importlib import reload  # Python 3.4+ only.
#reload(ergodicity)


plt.figure(figsize=(8, 5), dpi=160)

def plot(n=150,iterations=1000):
    np.random.seed(1)
    delta_expected = 1.5*0.5+0.6*0.5 - 1 # <\Delta x>
    time_average = np.log(1.5)*0.5+np.log(0.6)*0.5 # <\Delta ln x>

    history = np.matrix(ergodicity.walk_incest(iterations,n,incest=0.05))
    
    for i in range(n):
        plt.plot(np.log10(history[:,i]))


    plt.plot([0,iterations],np.log10([1,(1+delta_expected)**iterations ]) , color="black")
    plt.plot([0,iterations],np.log10([1,(1+time_average)**iterations ]), color="black" )
    
    plt.xticks(fontsize=12) # rotation=90
    plt.yticks(fontsize=12) # rotation=90

    plt.ylabel("Size (log scale)", fontsize=16 )
    plt.xlabel("Time", fontsize=16 )
    plt.savefig(name+".pdf",pad_inches =0,transparent =True,frameon=True)
    plt.savefig(name+".png",pad_inches =0,transparent =True,frameon=True,dpi=90)
    
if __name__ == "__main__":
    plot(33,iterations=1000)
    bash_cmd = "pdfcrop --margins '0 0 0 0' {0}.pdf {0}.pdf".format(name)
    os.system(bash_cmd)
    
