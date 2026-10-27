settings
holdLimit

	"How long a held image waits for a request before its agent lets it go: an hour unless set,
	nil for ever. So an observer that died does not hold it for ever."

	HoldLimit ifNil: [ ^ 60 minutes ].
	^ HoldLimit == #never ifFalse: [ HoldLimit ]
