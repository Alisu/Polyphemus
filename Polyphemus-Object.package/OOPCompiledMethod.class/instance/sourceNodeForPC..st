debugger protocol
sourceNodeForPC: aPC

	"Where a pc is in the source: through this method compiled here, when it is byte for byte
	the image's."

	^ (memory hostMethodOfMethod: self)
		  ifNil: [ OOPUnknownSourceNode new ]
		  ifNotNil: [ :host |
			  [ host sourceNodeForPC: aPC ] on: Error do: [ :e | OOPUnknownSourceNode new ] ]
