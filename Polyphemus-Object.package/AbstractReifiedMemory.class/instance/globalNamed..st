globals
globalNamed: aName

	"The binding of a global in the image being read, or nil: never one of our own globals, which
	would answer this image's Object and Smalltalk. Refused where the globals do not read, or
	where the name is not found and some of them do not say theirs (#118)."

	^ self globalsByName at: aName asString ifAbsent: [
		  globalsPassedOver > 0
			  ifTrue: [
				  NotInTheReading signal: globalsPassedOver printString
					  , ' of its globals do not read: whether this image has ' , aName asString , ' cannot be told' ]
			  ifFalse: [ nil ] ]
