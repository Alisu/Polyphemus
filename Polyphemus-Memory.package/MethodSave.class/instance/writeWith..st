saving
writeWith: aBlock

	"Save the source by aBlock if it parses; answers whether it was saved, telling what stopped it
	at the error, at the method's start for anything aBlock signals, or what a partial save did."

	self parseError ifNotNil: [ :error | ^ self tell: error errorMessage at: error start ].
	^ [
	  [
	  aBlock value.
	  true ]
		  on: PartlySaved
		  do: [ :partly | self saved: partly messageText ] ]
		  on: Error
		  do: [ :error | self tell: error messageText at: 1 ]
