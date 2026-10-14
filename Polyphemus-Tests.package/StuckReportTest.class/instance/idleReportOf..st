helpers
idleReportOf: aPid

	"Idle most of the time, not every instant: look again, up to 15 s, until caught waiting
	without having been stopped to look, which a thread caught running makes it do (#31)."

	| report |
	60 timesRepeat: [
		report := Polyphemus whereIsStuck: aPid.
		(report mainThread isWaitingForEvents and: [ report stoppedToLook not ]) ifTrue: [ ^ report ].
		(Delay forMilliseconds: 250) wait ].
	^ report
