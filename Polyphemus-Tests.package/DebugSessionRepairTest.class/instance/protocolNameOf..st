helpers
protocolNameOf: aMethod

	"Pharo 10 answers a method's protocol as a Symbol, Pharo 13 as a Protocol, named."

	| protocol |
	protocol := aMethod protocol.
	^ (protocol isString ifTrue: [ protocol ] ifFalse: [ protocol name ]) asString
