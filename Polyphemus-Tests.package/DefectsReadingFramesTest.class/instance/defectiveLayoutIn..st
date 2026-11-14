running
defectiveLayoutIn: aSelector

	"The reading's layout as it reads, but with a defect of our own where aSelector is answered."

	^ (DefectiveReadDouble of: reifiedMemory vmLayout) when: aSelector answer: [ 1 / 0 ]
