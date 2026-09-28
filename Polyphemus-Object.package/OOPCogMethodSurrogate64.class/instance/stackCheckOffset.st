accessing
stackCheckOffset

	"Twelve bits from bit 3 of the header's third byte, where VM 12 has them."

	^ ((memory unsignedShortAt: address + 2 + baseHeaderSize) bitShift: -3) bitAnd: 16rFFF
