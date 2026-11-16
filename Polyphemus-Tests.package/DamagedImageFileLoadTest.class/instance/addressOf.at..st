damaging
addressOf: aSymbol at: aNumber

	"Where the matrix overwrites: a slot of the special objects array, of the scheduler, of the
	running process or of its context, or the header or first word of the first object of a format."

	| running |
	aSymbol = #special ifTrue: [ ^ DamagedCandleImage slot: aNumber of: clean reifiedSpecialObjectArray ].
	aSymbol = #header ifTrue: [ ^ (self firstObjectOfFormat: aNumber) address ].
	aSymbol = #firstWord ifTrue: [ ^ (self firstObjectOfFormat: aNumber) address + 8 ].
	aSymbol = #scheduler ifTrue: [ ^ DamagedCandleImage slot: aNumber of: clean processes reifiedScheduler ].
	running := clean processes reifiedActiveProcess.
	aSymbol = #process ifTrue: [ ^ DamagedCandleImage slot: aNumber of: running ].
	^ DamagedCandleImage slot: aNumber of: (clean contextsOfProcess: running) first
