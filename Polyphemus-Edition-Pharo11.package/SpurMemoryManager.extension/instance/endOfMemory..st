*Polyphemus-Edition-Pharo11
endOfMemory: anAddress
	"Where old space ends, set as v10.0.0 set its variable: v10.0.5 keeps it in its memory map,
	which has no setter for it."

	self getMemoryMap instVarNamed: 'oldSpaceEnd' put: anAddress
