contexts
whyNoActivationOfProcess: aProcessOop

	"For a process whose stack is empty: nil when it has none, as one that ended; else why none
	was read, in a sentence: its suspended context does not read or is no context, or it was
	running and its frames are refused."

	| context |
	context := [ aProcessOop reifiedSlotAt: memory processSuspendedContextSlot ]
		           on: PolyphemusError
		           do: [ :refusal | ^ 'the suspended context of the process does not read: ' , refusal messageText ].
	context isNilOop ifFalse: [
		^ context isContextOop ifFalse: [
			  'the suspended context of the process is no context: ' , context whatItReadsAs ] ].
	^ [
	  aProcessOop address = memory reifiedActiveProcess address ifTrue: [ memory vmLayout framesOfActiveProcess ].
	  nil ]
		  on: PolyphemusError
		  do: [ :refusal | refusal messageText ]
