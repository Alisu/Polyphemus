writing
read: aName from: someVariables

	"A variable of the dumped VM, for the header written: refused when it does not read, as a 0
	written in its place would be a header the VM did not have (#182)."

	^ [ someVariables at: aName ]
		  on: Error
		  do: [ :e | NotInTheReading signal: 'the dumped VM''s ' , aName , ' does not read: ' , e messageText asString ]