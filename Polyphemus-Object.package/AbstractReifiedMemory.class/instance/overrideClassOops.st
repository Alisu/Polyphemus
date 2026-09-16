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

	"An entry no handler claims is not a class, whatever the table says it is. That used to
	raise here and take the whole memory down with it; it is left as it is instead, so that
	the objects pointing at it come out with an OOPUnreadableClass and the rest of the heap
	is read as normal."
	self reifiedClassTable classOopsDo: [ :aClass |
		handlers
			detect: [ :anHandler | anHandler canHandle: aClass address memory: self ]
			ifFound: [ :handler |
				self objectAt: aClass address put: (handler on: aClass address memory: self) ]
			ifNone: [  ] ]
