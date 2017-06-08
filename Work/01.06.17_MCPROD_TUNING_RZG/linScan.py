import os
import numpy as np
import sys

def SubDirPath (d):
    return filter(os.path.isdir, [os.path.join(d,f) for f in os.listdir(d)])


for d in SubDirPath("."):
     if d.find("7000")!=-1:
	print d
	os.chdir(d)
	print "Merging YODA file "+d.split("/")[1]
	os.system("yodamerge */*177.yoda -o "+d.split("/")[0]+"_177.yoda")

	os.chdir("../")

     if d.find("8000")!=-1:
        print d
        os.chdir(d)
        print "Merging YODA file "+d.split("/")[1]
	os.system("yodamerge */*253.yoda -o "+d.split("/")[0]+"_253.yoda")

        os.chdir("../")

     if d.find("13000")!=-1:
        print d
        os.chdir(d)
        print "Copying YODA file "+d.split("/")[1]
	os.system("yodamerge */*253.yoda -o "+d.split("/")[0]+"_253.yoda")


	os.chdir("../")
	
