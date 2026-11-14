accessing
processDamagedIn: aName

	"The process of the damaged copy one of whose frames was damaged so (#methodField,
	#savedFramePointer); nil where the clean core had no stack deep enough for it."

	| memory |
	memory := self memory.
	^ (Damaged at: aName ifAbsent: [ ^ nil ]) in: [ :address |
		  memory allReifiedProcesses detect: [ :each | each address = address ] ]
