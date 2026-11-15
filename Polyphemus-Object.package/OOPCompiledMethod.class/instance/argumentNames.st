debugger protocol
argumentNames

	"As its source declares them, or none when it cannot be read or does not parse."

	| source |
	source := [ self getSourceFromFile ] on: PolyphemusError do: [ :refusal | ^ #(  ) ].
	^ ForeignCode
		  askingPharo: [ (AbstractReifiedMemory parserClass parseMethod: source) argumentNames ]
		  ifItFails: [ #(  ) ]
