making
withHash: aHash in: aHeader

	^ (aHeader bitAnd: (self hashMask bitShift: 32) bitInvert) + (aHash bitShift: 32)
