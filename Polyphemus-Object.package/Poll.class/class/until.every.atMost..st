waiting
until: aBlock every: aDuration atMost: aCount

	"Whether aBlock comes true: asked at once, then again after each wait of aDuration, aCount waits
	at most. The last wait is followed by a last look."

	aCount timesRepeat: [
		aBlock value ifTrue: [ ^ true ].
		(Delay forMilliseconds: aDuration asMilliSeconds) wait ].
	^ aBlock value
