private
refuseItsCaller

	"Refuses by name the frame below one whose saved frame pointer leads to none (#198)."

	^ (SpurCannotRead new
		   level: #frame reason: whyNoCaller;
		   detail: 'the frame at ' , (framePointer printStringRadix: 16) , ' saves '
			   , ((self layout wordAt: framePointer) printStringRadix: 16);
		   yourself) signal
