running
frame

	"A context of the image whose method has temporaries, named on this host or not."

	self memory allReifiedProcesses do: [ :each |
		(self memory contextsOfProcess: each) do: [ :context |
			context method numTemps > 0 ifTrue: [ ^ context ] ] ].
	^ self fail: 'no context whose method has temporaries'
