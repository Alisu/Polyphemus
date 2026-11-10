tests
testEveryRequestIsNotedOnTheReading

	"#168: a request allocates in the image; an edit through a reading taken before it may write
	where an object no longer is."

	| log channel held |
	log := OrderedCollection new.
	channel := ScriptedChannel answering: #( nil nil nil '3' ).
	held := HeldProcess on: channel reader: nil identityHash: 7.
	channel log: log.
	held instVarNamed: 'heldReading' put: (ReadingRecordingDouble new log: log; yourself).
	held ask: '3'.
	self assert: log asArray equals: #( #noted #asked )
