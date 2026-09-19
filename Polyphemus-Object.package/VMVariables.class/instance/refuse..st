private
refuse: aReason

	^ (SpurCannotRead new level: #vm reason: aReason) signal
