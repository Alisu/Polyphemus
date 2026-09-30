categories
rankOf: aCode

	"Nothing, free, any ordinary kind, then pinned, forwarder and unreadable, which show through."

	aCode <= 1 ifTrue: [ ^ aCode ].
	aCode <= 6 ifTrue: [ ^ 2 ].
	^ aCode - 4
