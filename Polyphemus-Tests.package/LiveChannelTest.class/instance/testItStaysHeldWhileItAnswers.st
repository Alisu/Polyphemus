tests
testItStaysHeldWhileItAnswers

	"A process forked below the agent never gets to run while the agent serves: the image is
	held for as long as we talk to it, and let go only when told."

	self withAnAgentIn: self launchSpinningTarget do: [ :channel |
		channel ask: 'Smalltalk at: #PolyphemusFlag put: false. [ Smalltalk at: #PolyphemusFlag put: true ] forkAt: 40. nil'.
		channel ask: 'nil'.
		self assert: (channel ask: 'Smalltalk at: #PolyphemusFlag') equals: 'false'.
		channel letGo.
		self
			assert: (self waitFor: [ (self spikeDirectory / 'released') exists ])
			description: 'it never let go' ]
