accessing
cmUsageCount

	^ ((memory unsignedByteAt: address + 1 + baseHeaderSize) bitShift: -4) bitAnd: 16r7
