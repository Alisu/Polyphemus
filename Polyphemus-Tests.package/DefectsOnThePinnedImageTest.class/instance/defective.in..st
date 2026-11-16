running
defective: anObject in: aSelector

	"anObject as it reads, but with a defect of our own where aSelector is answered."

	^ (DefectiveReadDouble of: anObject) when: aSelector answer: [ 1 / 0 ]
