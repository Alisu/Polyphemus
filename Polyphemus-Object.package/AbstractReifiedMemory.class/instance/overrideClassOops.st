initialization
overrideClassOops
	| handlers |
	handlers := OrderedCollection new.
	metaclassForTraitIndex ifNotNil:[ 	
		handlers addAll: OOPClassClassSideObject subclasses.
		handlers addAll: OOPClassInstanceSideObject subclasses.
	].
	handlers add: OOPClassClassSideObject.
	handlers add: OOPClassInstanceSideObject.

	"An entry no handler claims is not a class, whatever the table says: left as it is, so what
	points at it reads as an OOPUnreadableClass and the rest of the heap as normal (raising here
	took the whole memory down)."
	self reifiedClassTable classOopsDo: [ :aClass |
		handlers
			detect: [ :anHandler | anHandler canHandle: aClass address memory: self ]
			ifFound: [ :handler |
				self objectAt: aClass address put: (handler on: aClass address memory: self) ]
			ifNone: [  ] ]
