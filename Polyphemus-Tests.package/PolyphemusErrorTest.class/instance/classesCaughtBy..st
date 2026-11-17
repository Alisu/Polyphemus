running
classesCaughtBy: aNode

	"The names in what an on:do: is given: a class, or classes joined by commas, read by hand so
	that it does not depend on what a Pharo's nodes count among their children."

	aNode isVariable ifTrue: [ ^ { aNode name asString } ].
	(aNode isMessage and: [ aNode selector = #, ]) ifFalse: [ ^ #(  ) ].
	^ (self classesCaughtBy: aNode receiver) , (self classesCaughtBy: aNode arguments first)
