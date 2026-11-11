holding
whileStoppedOnAProcessItCanHold: aBlock

	"aBlock's value, the image stopped while a process the watcher outranks has the processor: one
	at its priority or above runs on through a hold (#172). Stopped again a few times, the last
	stop taken as it is."

	| answer |
	1 to: self triesForAProcessItCanHold do: [ :try |
		answer := reader whileStopped: [
			          (self watcherOutranksTheActiveProcess or: [ try = self triesForAProcessItCanHold ])
				          ifTrue: [ { aBlock value } ] ].
		answer ifNotNil: [ ^ answer first ].
		(Delay forMilliseconds: 5) wait ]
