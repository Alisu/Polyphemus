tests
testLettingGoAnImageThatIsGoneRingsNothing

	"Ringing stops the image's process, which is gone: letting go answers at once that nothing
	was there to let go (#127)."

	| rung |
	channel ask: 'nil'.
	agent terminate.
	rung := false.
	channel
		ringing: [ rung := true ];
		whyGone: [ 'its process 4242 ended' ].
	self deny: (channel letGoWithin: 1 minute).
	self deny: rung
