reading
hashOf: aHeader

	^ (aHeader bitShift: -32) bitAnd: self hashMask
