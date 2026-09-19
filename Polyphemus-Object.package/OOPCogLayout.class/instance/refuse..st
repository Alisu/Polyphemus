private
refuse: aReason

	^ (SpurCannotRead new level: #frame reason: aReason) signal
