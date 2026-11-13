tests
testATestWhoseTargetEndedSaysWhatItsLogHolds

	"#190: 'its process ended' alone does not tell a crash from a kill."

	| said |
	said := [ LiveRunUntilTest new sayingHowTheTargetEnded: [ HeldImageGone signal: 'the image is gone: its process 42 ended' ] ]
		        on: HeldImageGone
		        do: [ :gone | gone messageText ].
	self assert: (said beginsWith: 'the image is gone: its process 42 ended; it').
	self assert: (said includesSubstring: ' log')
