helpers
withTheRunawayHeldDo: aBlock

	"The spinning target held, and its runaway process in the hands of its own debugger."

	self withAnAgentIn: self launchSpinningTarget do: [ :channel :reader |
		aBlock
			value: (HeldProcess on: channel identityHash: (self runawayHashIn: reader))
			value: reader ]
