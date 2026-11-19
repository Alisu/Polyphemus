private
heldIn: aReading

	"The held process in that reading: where it was last found if it is still there, else in the slot of
	the external objects table the agent put it in (#129), else in a run queue, else by a walk over the
	heap -- suspended while held, it is in no queue (#103)."

	| found |
	(address notNil and: [ self hasTheHeldProcessesHeaderAt: address in: aReading ]) ifTrue: [
		found := aReading reifyOop: address.
		(self isTheHeldProcess: found) ifTrue: [ ^ found ] ].
	slot ifNotNil: [
		found := [ (aReading reifiedSpecialObjectArray reifiedSlotAt: 39) reifiedSlotAt: slot ]
			         on: PolyphemusError
			         do: [ :refusal | nil ].
		(self isTheHeldProcess: found) ifTrue: [
			address := found address.
			^ found ] ].
	found := aReading runnableProcesses
		         detect: [ :each | each oopHash = hash ]
		         ifNone: [ self processIn: aReading of: dumped ].
	address := found address.
	^ found
