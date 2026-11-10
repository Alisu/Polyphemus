tests
testTheReadingIsTheLastThingTheDebuggersContextAsksFor

	"#168: the depth was asked of the image after the reading, its compiling and evaluating then
	filling eden: a scavenge, and the edit that followed refused as stale."

	| log channel held |
	log := OrderedCollection new.
	channel := ScriptedChannel answering: #( nil nil nil '1' ).
	held := HeldProcess on: channel reader: nil identityHash: 7.
	channel log: log.
	held instVarNamed: 'heldReading' put: (ReadingRecordingDouble new log: log; yourself).
	self assert: held context equals: #below.
	self assert: log last equals: #read
