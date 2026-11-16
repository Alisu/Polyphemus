damaging
refusalOfACopyDamagedBy: aDamage

	"The refusal that reading a copy of Candle with that address -> word raises; an error that is
	not ours passes, and a copy that reads fails the test."

	| refusal |
	self withACopyDamagedBy: aDamage do: [ :copy |
		[ Polyphemus readImageFile: copy fullName ]
			on: SpurCannotRead
			do: [ :raised | refusal := raised ] ].
	self assert: refusal notNil description: 'the damaged copy was read'.
	^ refusal
