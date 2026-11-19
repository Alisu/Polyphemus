private
refuse: aReason

	"What cannot be read of a frame, by name: either layout refuses so."

	^ (SpurCannotRead new level: #frame reason: aReason) signal
