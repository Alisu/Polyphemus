enumerating
collect: aBlock

	"The same ranges, each object put through aBlock; what comes out nil is not kept."

	| collected |
	collected := Dictionary new.
	objects keysAndValuesDo: [ :address :each |
		(aBlock value: each) ifNotNil: [ :result | collected at: address put: result ] ].
	^ self class new setRanges: ranges objects: collected
