reading
sharingClassesOn: aMemory

	"A reading of another copy of the same image, taking over this one's classes and class table
	rebound to it: what makes a reading slow to build, and what a step does not change. Both
	readings stay valid, each on its own copy."

	| other rebound kept |
	other := self shallowCopy.
	rebound := IdentityDictionary new.
	rebound at: self put: other.
	kept := objectsArray collect: [ :each |
		        (each notNil and: [ each isClassSideOfTheReading ])
			        ifTrue: [ rebound at: each put: each shallowCopy ]
			        ifFalse: [ nil ] ].
	rebound keysAndValuesDo: [ :old :new |
		old == self ifFalse: [ new reboundThrough: rebound ] ].
	other rebaseOn: aMemory keeping: kept.
	self class cache add: other.
	^ other
