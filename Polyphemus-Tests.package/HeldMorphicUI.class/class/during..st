holding
during: aBlock

	"aBlock, with Morphic's UI process parked between two cycles, where it holds no lock (#59):
	by a message it runs itself, never suspended from outside."

	| ui parked release |
	ui := self uiProcess.
	(ui isNil or: [ ui == Processor activeProcess ]) ifTrue: [ ^ aBlock value ].
	parked := Semaphore new.
	release := Semaphore new.
	self currentWorld defer: [
		parked signal.
		release wait ].
	(parked waitTimeoutSeconds: 5) ifTrue: [
		release signal.
		^ aBlock value ].
	^ aBlock ensure: [ release signal ]
