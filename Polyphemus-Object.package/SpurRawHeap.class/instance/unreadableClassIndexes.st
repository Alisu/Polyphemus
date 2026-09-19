checking
unreadableClassIndexes

	"The class indexes whose entry is not a class. Their objects still read; they only have no
	name to give."

	^ (self classTableProblems
		   reject: [ :each | self scanner structuralClassTableReasons includes: each key ])
		  collect: [ :each | each value ]
