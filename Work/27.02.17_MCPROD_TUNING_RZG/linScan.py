import os
import numpy as np
import sys

def SubDirPath (d):
    return filter(os.path.isdir, [os.path.join(d,f) for f in os.listdir(d)])

def findYODA(i,j,k,index):

  print i,j,k
  for d in SubDirPath("."):
    if d.find(str(i)+"_"+str(j)+"_"+str(k))!=-1:

	print d
	os.chdir(d)
	print "Copying YODA file "+d.split("/")[1]
	os.system("cp *177.yoda ../scan/mc/"+str(index))
	os.chdir("..")
  os.chdir("scan")
	

alphaSMZ = [0.125, 0.140]
ClMaxLight = [0.5, 3.5]
PSplitLight = [0.5, 3.5]

nsteps = 2 
nstepsClMaxLight = 3
nstepsPSplit = 3


if os.path.isdir("scan"):
  sys.exit("Scan directory already exists... Aborting.")

os.system("mkdir scan")
os.chdir("scan")

index=0

print "Making /scan directory and copying YODA files..."

for i in np.linspace(alphaSMZ[0], alphaSMZ[1], nsteps):
  for j in np.linspace(ClMaxLight[0], ClMaxLight[1], nstepsClMaxLight):
    for k in np.linspace(PSplitLight[0], PSplitLight[1], nstepsPSplit):

	os.system("mkdir -p mc/"+str(index))
	os.chdir("mc/"+str(index))
	parFile = open("params.dat", 'w')

	parFile.write("alphaSMZ\t"+str(i)+"\n")
	parFile.write("ClMaxLight\t"+str(j)+"\n")
	parFile.write("PSplitLight\t"+str(k))

	parFile.close()

	os.chdir("../../../")
	findYODA(i,j,k,index)

	index += 1


	
