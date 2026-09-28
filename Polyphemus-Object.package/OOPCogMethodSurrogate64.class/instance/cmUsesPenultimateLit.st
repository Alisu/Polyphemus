accessing
cmUsesPenultimateLit

	^ (((memory unsignedByteAt: address + 1 + baseHeaderSize) bitShift: -7) bitAnd: 16r1) ~= 0
