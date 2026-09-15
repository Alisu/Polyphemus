reading headers
formatIn: aHeader

	^ (aHeader bitShift: -24) bitAnd: 16r1F
