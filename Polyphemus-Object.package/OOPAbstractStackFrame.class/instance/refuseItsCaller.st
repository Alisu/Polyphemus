private
refuseItsCaller

	"Refuses by name the frame below one whose saved frame pointer leads to none (#198)."

	^ (SpurCannotRead new
		   level: #frame reason: whyNoCaller;
		   detail: 'the frame at ' , (framePointer printStringRadix: 16) , ' saves '
			   , ((self layout wordAt: framePointer) ifNil: [ 'a word that is not read' ] ifNotNil: [ :saved | saved printStringRadix: 16 ]);
		   yourself) signal
