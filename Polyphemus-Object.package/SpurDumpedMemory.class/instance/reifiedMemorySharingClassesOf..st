accessing
reifiedMemorySharingClassesOf: aReading

	"A LazyReifiedMemory of this copy taking aReading's classes over: see holdsTheClassesOf:."

	| reified |
	reified := aReading sharingClassesOn: self memory.
	reified vmLayout: (OOPCogLayout on: reified raw: raw).
	^ reified
