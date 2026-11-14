tests
testWhatVMMakerSignalsOutsideItsMemoryIsOneThingToCatchAndADefectIsNot

	"#118: no region for an address is VMMaker's KeyNotFound; past the bytes of its last region,
	in Pharo 10's, a PrimitiveFailed. Both are caught as one, and nothing else is."

	self assert: ([ KeyNotFound signalFor: 1 ] on: OutsideTheSimulatorsMemory do: [ :e | #caught ]) equals: #caught.
	self assert: ([ PrimitiveFailed new signal ] on: OutsideTheSimulatorsMemory do: [ :e | #caught ]) equals: #caught.
	self should: [ [ 1 / 0 ] on: OutsideTheSimulatorsMemory do: [ :e | #caught ] ] raise: ZeroDivide
