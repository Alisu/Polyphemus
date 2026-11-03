inspection
inImageDescription

	^ (self oopClassName includesSubstring: 'Symbol')
		  ifTrue: [ '#' , self asString ]
		  ifFalse: [ self asString printString ]
