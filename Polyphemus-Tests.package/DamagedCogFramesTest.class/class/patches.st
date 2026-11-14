accessing
patches

	"address -> word, what the core is made to hold there for the time of a test."

	^ Patches ifNil: [ Patches := Dictionary new ]
