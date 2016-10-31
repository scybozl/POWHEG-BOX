import yoda
import math

fi=yoda.read("Rivet.yoda", asdict=False)

aos = []
for h in fi:
    if h.annotation("Type") == "Histo1D":
	s=yoda.Scatter2D()

	for a in h.annotations:
	  s.setAnnotation(a, h.annotation(a))
	s.setAnnotation("Type", "Scatter2D")

	for b in h.bins:
	  x = b.xMid
	  ex = x - b.xMin
	  y = b.height
	  ey = b.heightErr

	  s.addPoint(x,y,ex,ey)
	  
        aos.append(s)
    else: aos.append(h)

print aos
yoda.write(aos, "Rivet_scatter.yoda")
