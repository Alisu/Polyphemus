helpers
idleReportOf: aPid

	"An idle image is idle most of the time, not every instant: just launched it may still be
	starting, or awake for a timer, and a report then stops it to look (CI, Pharo 13,
	2026-10-12). Look again, up to 5 s, until it is caught waiting."

	| report |
	20 timesRepeat: [
		report := Polyphemus whereIsStuck: aPid.
		report mainThread isWaitingForEvents ifTrue: [ ^ report ].
		(Delay forMilliseconds: 250) wait ].
	^ report
