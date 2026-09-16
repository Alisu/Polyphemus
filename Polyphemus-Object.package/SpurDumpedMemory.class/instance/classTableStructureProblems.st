checking
classTableStructureProblems

	"Only the problems that stop the table working at all."

	^ self classTableProblems select: [ :each |
		  self scanner structuralClassTableReasons includes: each key ]
