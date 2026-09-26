checking
refusalOfTarget: aMajor

	"Why this edition should not read an image of that Pharo, or nil."

	(targets includes: aMajor) ifTrue: [ ^ nil ].
	^ 'this is ' , self name , ', which does not read Pharo ' , aMajor printString
