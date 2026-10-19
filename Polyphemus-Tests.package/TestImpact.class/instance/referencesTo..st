private
referencesTo: aClass

	"What to follow from the methods referring to aClass, once for each class."

	(rooted includes: aClass) ifTrue: [ ^ #(  ) ].
	rooted add: aClass.
	^ (SystemNavigation default allReferencesTo: (Smalltalk globals associationAt: aClass name))
		  flatCollect: [ :each | self reach: each compiledMethod ]
