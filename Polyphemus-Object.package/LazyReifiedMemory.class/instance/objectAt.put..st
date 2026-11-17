accessing
objectAt: anAddress put: anObject

	"As any reading; an address refused because the heap was cut where its walk stopped is refused
	saying that, where and why (#211)."

	^ [ super objectAt: anAddress put: anObject ]
		  on: NotInTheReading
		  do: [ :refusal |
			  (self whyPastWhatWasWalked: anAddress)
				  ifNil: [ refusal pass ]
				  ifNotNil: [ :why | NotInTheReading signal: refusal messageText , why ] ]
