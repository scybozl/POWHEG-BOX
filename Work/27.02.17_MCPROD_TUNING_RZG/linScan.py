import os
import numpy as np
import sys

def SubDirPath (d):
    return filter(os.path.isdir, [os.path.join(d,f) for f in os.listdir(d)])

def findYODA(i,j,k,index):

  print i,j,k
  for d in SubDirPath("."):
    if d.find(str(i)+"_"+str(j)+"_"+str(k))!=-1:

     if d.find("7000")!=-1:
	print d
	os.chdir(d)
	print "Copying YODA file "+d.split("/")[1]
	os.system("cp *177.yoda ../scan/mc/"+str(index))

	os.chdir("../scan/mc/"+str(index))
	for f in os.listdir("."):
	  if f.find(".yoda")!=-1 and f.find("7000")!=-1:
	    name = f	

	    lines = open(name,'r').readlines()
	    newYODA = open(str(index)+"_7TeV.yoda",'w')
	    flag = True
	    for line in lines:
	      if line.find("ATLAS_2013_")!=-1:
	        flag = False
	      if line.find("ATLAS_2014_")!=-1:
	        flag = True
	      if flag == True:
	        newYODA.writelines(line)
	    os.system("rm "+name)
#	    os.system("yoda2aida "+str(index)+".yoda "+str(index)+".aida")


	os.chdir("../../../")
     if d.find("8000")!=-1:
        print d
        os.chdir(d)
        print "Copying YODA file "+d.split("/")[1]
        os.system("cp *253.yoda ../scan/mc/"+str(index))

	os.chdir("../scan/mc/"+str(index))
        for f in os.listdir("."):
          if f.find(".yoda")!=-1 and f.find("8000")!=-1:
            name = f

            lines = open(name,'r').readlines()
            newYODA = open(str(index)+"_8TeV.yoda",'w')
            flag = True
            for line in lines:
              if line.find("Parton")!=-1:
                flag = False
              if line.find("custom")!=-1:
                flag = True
              if flag == True:
                newYODA.writelines(line)
            os.system("rm "+name)


        os.chdir("../../../")
  os.chdir("scan")
	

alphaSMZ = [0.125, 0.140]
ClMaxLight = [0.5, 3.5]
PSplitLight = [0.5, 3.5]

nsteps = 4 
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


	
