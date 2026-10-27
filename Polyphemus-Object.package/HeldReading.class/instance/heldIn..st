private
heldIn: aReading

	"The held process in that reading: where it was last found if it is still there (only a compacting
	collection moves it), else in a run queue, else by a walk over the heap -- suspended while held, it
	is in no queue (#103), and walking for it each step took a second more."

	| found |
	address ifNotNil: [
		found := [ aReading reifyOop: address ] on: Error do: [ :e | nil ].
		(found notNil and: [ ([ found oopHash = hash and: [ found oopClassName = 'Process' ] ] on: Error do: [ :e | false ]) ])
			ifTrue: [ ^ found ] ].
	found := aReading runnableProcesses
		         detect: [ :each | each oopHash = hash ]
		         ifNone: [ self processIn: aReading of: dumped ].
	address := found address.
	^ found
