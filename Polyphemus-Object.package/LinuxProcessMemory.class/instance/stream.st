reading
stream

	"The file itself, not a buffered stream over it: each read goes to the file once."

	^ stream ifNil: [
		  stream := (File named: (self pathFor: 'mem') asFileReference fullName) openForRead ]
