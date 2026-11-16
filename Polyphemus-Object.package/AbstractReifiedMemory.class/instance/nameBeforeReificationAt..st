initialization
nameBeforeReificationAt: anAddress

	"The string at anAddress, read before anything is reified. A free chunk or a forwarder there
	is refused by name: VMMaker asserts on the size of one (#207)."

	^ self readAt: anAddress through: [
		  (memory classIndexOf: anAddress) > memory isForwardedObjectClassIndexPun ifFalse: [
			  NotInTheReading signal: 'the word ' , (anAddress printStringRadix: 16) , ' is the address of no object' ].
		  (OOPString on: anAddress memory: memory) asString ]
