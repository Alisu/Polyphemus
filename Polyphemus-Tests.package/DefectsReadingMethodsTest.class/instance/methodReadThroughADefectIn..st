running
methodReadThroughADefectIn: aSelector

	"The method, read through a reading that has a defect of our own where aSelector is answered."

	^ self method copy
		  memory: ((DefectiveReadDouble of: self memory) when: aSelector answer: [ 1 / 0 ]);
		  yourself
