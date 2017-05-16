import os
import numpy as np
import sys

def SubDirPath (d):
    return filter(os.path.isdir, [os.path.join(d,f) for f in os.listdir(d)])

def SubFile(d):
    return filter(os.path.isfile, [os.path.join(d,f) for f in os.listdir(d)])

for subdir in SubDirPath("."):
    os.chdir(subdir)
    os.system("mv params.dat used_params")
    
    for files in SubFile("."):
	if files.find("7TeV")!=-1 or files.find("8TeV")!=-1:
	  os.system("yoda2aida "+files+" "+files.split(".yoda")[0]+".aida")
#	  print "yoda2aida "+files+" "+files.split(".yoda")[0]+".aida"	

    os.chdir("../")
