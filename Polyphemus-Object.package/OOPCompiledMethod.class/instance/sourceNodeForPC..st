debugger protocol
sourceNodeForPC: aPC

	"Where a pc is in the source: through this method compiled here, when it is byte for byte
	the image's. Unknown where the method does not read or Pharo does not say."

	| host |
	host := [ memory hostMethodOfMethod: self ] on: PolyphemusError do: [ :refusal | nil ].
	host ifNil: [ ^ OOPUnknownSourceNode new ].
	^ ForeignCode askingPharo: [ host sourceNodeForPC: aPC ] ifItFails: [ OOPUnknownSourceNode new ]
