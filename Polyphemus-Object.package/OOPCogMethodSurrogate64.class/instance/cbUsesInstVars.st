accessing
cbUsesInstVars

	^ ((memory unsignedByteAt: address + 2 + baseHeaderSize) bitAnd: 16r1) ~= 0
