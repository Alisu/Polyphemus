guessing
classesDo: aBlock
	"Each class of the class table once, with the class index of its instances."

	| seen |
	seen := Set new.
	memory classTableObjectsDo: [ :aClass |
		| classIndex |
		classIndex := memory rawHashBitsOf: aClass.
		((seen includes: classIndex) not and: [ (memory classAtIndex: classIndex) = aClass ]) ifTrue: [
			seen add: classIndex.
			aBlock value: aClass value: classIndex ] ]
