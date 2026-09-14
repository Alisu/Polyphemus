"Build warm.image: every fixture already in place, so test processes skip loading
 images into the simulator. The Pharo 10 snapshot costs ~40s to open; doing it once
 here means no test process pays it."
| warm |
warm := [ :label :block |
	[ block value. (label , ' ready') traceCr ]
		on: Error
		do: [ :e | ('WARM ERR ' , label , ' :: ' , e messageText asString) traceCr ] ].

warm value: 'stack page fixture' value: [
	StackPageReificationTest currentImage availableFor: StackPageReificationTest new ].
warm value: 'candle snapshot' value: [
	CandleSnapshotResource availableFor: SchedulerReificationTest new ].
warm value: 'pharo 10 snapshot' value: [
	Pharo10SnapshotResource availableFor: SchedulerOnRealImageTest new ].

Smalltalk snapshot: true andQuit: true
