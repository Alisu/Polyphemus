private
referencesTo: aClass

	"What to follow from the methods referring to aClass, once for each class."

	(rooted includes: aClass) ifTrue: [ ^ #(  ) ].
	rooted add: aClass.
	^ (self referencesOfOursTo: aClass) flatCollect: [ :each | self reach: each ]
