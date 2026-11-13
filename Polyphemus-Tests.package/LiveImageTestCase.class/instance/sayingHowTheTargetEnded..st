helpers
sayingHowTheTargetEnded: aBlock

	"aBlock's answer; a HeldImageGone it raises goes on saying what the target's log holds (#190)."

	^ aBlock on: HeldImageGone do: [ :gone |
		  gone messageText: gone messageText , '; ' , (self class endOf: (self targetLogIn: self spikeDirectory / 'target.log')).
		  gone pass ]
