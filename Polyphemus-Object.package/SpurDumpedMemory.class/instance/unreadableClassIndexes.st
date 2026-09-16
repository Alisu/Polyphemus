checking
unreadableClassIndexes

	"The class indexes whose entry is not a class.

	Objects of these classes are still perfectly readable -- their slots, their sizes, their
	contents -- they simply have no name to give. They are the anonymous ones, and it is
	worth knowing exactly which they are rather than refusing the whole memory over them."

	^ (self classTableProblems
		   reject: [ :each | self scanner structuralClassTableReasons includes: each key ])
		  collect: [ :each | each value ]
