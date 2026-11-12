holding it still
whileStoppedAtASafeMoment: aBlock

	"aBlock's value on a copy of its heap and the reader holding it still, at a safe moment: quiet
	and outside a collection within about two seconds, else outside one and in machine code, where
	the VM is in none of its own routines (whyNotToAllocateIn:, #167), looked for until
	#safeMomentWait has passed. Else refused, saying how often it looked and what the last stop saw (#91)."

	| tried stops deadline |
	40 timesRepeat: [
		tried := self
			         whileStoppedIf: [ :fresh |
				         fresh isQuiet
					         ifTrue: [ fresh whyCollecting ]
					         ifFalse: [ 'running, not waiting in the kernel' ] ]
			         do: aBlock.
		tried isArray ifTrue: [ ^ tried first ] ].
	stops := 40.
	deadline := DateAndTime now + self safeMomentWait.
	[
	stops := stops + 1.
	tried := self
		         whileStoppedIf: [ :fresh | self class whyNotToAllocateIn: (VMVariables on: fresh) ]
		         do: aBlock.
	tried isArray ifTrue: [ ^ tried first ].
	DateAndTime now > deadline ] whileFalse.
	^ SpurCannotRead new
		  level: #bytes reason: #itWasNeverStoppedAtASafeMoment;
		  detail: 'in ' , stops printString , ' stops, the last: ' , tried;
		  signal
