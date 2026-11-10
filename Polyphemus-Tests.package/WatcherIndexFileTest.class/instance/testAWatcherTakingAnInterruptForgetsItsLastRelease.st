tests
testAWatcherTakingAnInterruptForgetsItsLastRelease

	"Let go before a trap fired (runUntil:), it held again with released still there from that let
	go: taken for not holding, a second watcher went in (#163)."

	| source |
	source := PolyphemusAgent holdSourceAfterwards: ''.
	self assert: (source indexOfSubCollection: '''released'') ensureDelete') > 0.
	self assert: (source indexOfSubCollection: '''released'') ensureDelete') < (source indexOfSubCollection: '''interrupted'') ensureCreateFile')
