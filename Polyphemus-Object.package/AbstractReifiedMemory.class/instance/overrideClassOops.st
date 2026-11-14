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

	"An entry that reads as no class, or that no handler claims, is not one, whatever the table
	says: left as it is, so what points at it reads as an OOPUnreadableClass and the rest of the
	heap as normal (raising here took the whole memory down)."
	self reifiedClassTable classOopsDo: [ :aClass |
		(self classIsReadableAt: aClass address) ifTrue: [
			handlers
				detect: [ :anHandler | anHandler canHandle: aClass address memory: self ]
				ifFound: [ :handler |
					self objectAt: aClass address put: (handler on: aClass address memory: self) ]
				ifNone: [  ] ] ]
