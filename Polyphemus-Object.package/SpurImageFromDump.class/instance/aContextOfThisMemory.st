writing
aContextOfThisMemory

	"A context already in this memory, whose header says what a context's looks like here.
	Refused by name in a memory that has none."

	^ contextLikeness ifNil: [
		  | contexts |
		  contexts := self reified allReifiedProcesses flatCollect: [ :process | self reified contextsOfProcess: process ].
		  contexts ifEmpty: [ ^ NotInTheReading signal: 'no process of this memory has a context to make one like' ].
		  contextLikeness := contexts first address ]
