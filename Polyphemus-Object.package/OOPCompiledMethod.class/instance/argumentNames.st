debugger protocol
argumentNames

	"As its source declares them, or none when it cannot be read."

	^ [ (AbstractReifiedMemory parserClass parseMethod: self getSourceFromFile) argumentNames ]
		  on: Error
		  do: [ :e | #(  ) ]
