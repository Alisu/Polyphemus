reading
sharingClassesOn: aMemory

	"A reading of another copy of the same image, taking over this one's classes and class table
	rebound to it: what makes a reading slow to build, and what a step does not change. Not a
	class still in new space, which a scavenge moves (#189). Both readings stay valid."

	| other rebound kept |
	other := self shallowCopy.
	rebound := IdentityDictionary new.
	rebound at: self put: other.
	kept := objectsArray collect: [ :each |
		        (each notNil and: [ each isClassSideOfTheReading and: [ (each isClassOop and: [ each isYoungOop ]) not ] ])
			        ifTrue: [ rebound at: each put: each shallowCopy ]
			        ifFalse: [ nil ] ].
	rebound keysAndValuesDo: [ :old :new |
		old == self ifFalse: [ new reboundThrough: rebound ] ].
	other rebaseOn: aMemory keeping: kept.
	other takesItsClassesOver.
	self class cache add: other.
	^ other
