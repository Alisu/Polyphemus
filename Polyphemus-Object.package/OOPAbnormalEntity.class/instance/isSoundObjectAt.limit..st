guessing
isSoundObjectAt: anAddress limit: limitAddress
	"VMMaker's checks of its header, and a class for its class index unless it is a pun."

	^ [
	  (self couldBeObject: anAddress limit: limitAddress) and: [
		  | classIndex |
		  classIndex := memory classIndexOf: anAddress.
		  classIndex <= memory lastClassIndexPun or: [
			  ((memory classAtIndex: classIndex) ifNil: [ memory nilObject ]) ~= memory nilObject ] ] ]
		  on: Error
		  do: [ false ]
