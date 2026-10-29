debugger
doItSource

	"The source a DoIt keeps itself, in no sources file: in its trailer up to Pharo 11, in its
	properties from Pharo 12. Nil for a method."

	(#( #DoIt #DoItIn: ) includes: self selector) ifFalse: [ ^ nil ].
	self trailer sourceCode ifNotNil: [ :code | ^ code ].
	^ (self propertyAt: #source ifAbsent: [ nil ]) ifNotNil: [ :code |
		  (code isKindOf: OOPString) ifTrue: [ code asString ] ifFalse: [ nil ] ]
