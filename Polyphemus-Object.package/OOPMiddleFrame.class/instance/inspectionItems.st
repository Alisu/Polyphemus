inspection
inspectionItems 

	| items |
	items := super inspectionItems.
	items addFirst: #caller -> (caller ifNil: [ whyNoCaller ]).
	^items