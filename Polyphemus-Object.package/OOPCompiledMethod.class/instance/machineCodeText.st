inspection
machineCodeText

	"Cog's code for this method, read only, when the VM it was read from had compiled it; nil
	otherwise (#95)."

	^ (memory vmLayout machineCodeTextOf: address) ifNotNil: [ :text | self printString , String cr , text ]
