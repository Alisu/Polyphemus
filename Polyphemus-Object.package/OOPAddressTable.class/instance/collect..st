enumerating
collect: aBlock

	"The same ranges, each slot's value put through aBlock."

	^ self class new
		  setStarts: starts
		  slots: (slots collect: [ :array | array collect: aBlock ])
