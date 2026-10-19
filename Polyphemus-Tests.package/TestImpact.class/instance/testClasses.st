accessing
testClasses

	"The concrete test classes the changes call for."

	| frontier |
	tests ifNotNil: [ ^ tests ].
	tests := Set new.
	wide := Set new.
	seen := Set new.
	rooted := Set new.
	frontier := OrderedCollection new.
	selectors do: [ :each |
		| class everybodys |
		class := Smalltalk globals at: each key asSymbol ifAbsent: [ nil ].
		everybodys := (SystemNavigation default allImplementorsOf: each value) size > self wideLimit.
		(class notNil and: [ class inheritsFrom: TestCase ])
			ifTrue: [
				tests addAll: (class withAllSubclasses reject: [ :sub | sub isAbstract ]).
				everybodys ifFalse: [ frontier add: each value ] ]
			ifFalse: [
				everybodys
					ifTrue: [ wide add: each value ]
					ifFalse: [ frontier add: each value ] ] ].
	classes do: [ :each |
		(Smalltalk globals at: each asSymbol ifAbsent: [ nil ]) ifNotNil: [ :class |
			(class inheritsFrom: TestCase) ifTrue: [ tests addAll: (class withAllSubclasses reject: [ :sub | sub isAbstract ]) ].
			frontier addAll: (self referencesTo: class) ] ].
	self depth timesRepeat: [
		| next |
		next := OrderedCollection new.
		frontier do: [ :selector | next addAll: (self sendersOf: selector) ].
		frontier := next ].
	^ tests
