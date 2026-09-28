accessing
picHasMNUCaseOrCMIsFullBlock

	"A word of its own after selector, in VM 12."

	^ ((memory unsignedByteAt: address + 32 + baseHeaderSize) bitAnd: 16r1) ~= 0
