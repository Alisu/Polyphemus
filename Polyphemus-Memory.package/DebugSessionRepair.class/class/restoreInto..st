repairing
restoreInto: aSessionClass

	"Compile into aSessionClass whichever of Pharo's two methods it lacks, as Pharo has them, under
	an author of its own where the Pharo asks for one; answer the selectors given back."

	| missing compile |
	missing := self originals keys reject: [ :each | aSessionClass includesSelector: each ].
	compile := [
	           missing do: [ :each |
		           aSessionClass compile: (self originals at: each) value classified: (self originals at: each) key ] ].
	(Smalltalk at: #Author ifAbsent: [ nil ])
		ifNil: [ compile value ]
		ifNotNil: [ :author | author useAuthor: 'Polyphemus' during: compile ].
	^ missing
