checking
classTableProblems

	"What is wrong with the table that turns a class index into a class. Kept once found:
	auditing every entry of every page is half a minute, and a dump does not change."

	^ classTableProblems ifNil: [
		  classTableProblems := scanner
			                        classTableProblemsFrom: self heapStart
			                        upTo: mappingLimit ]
