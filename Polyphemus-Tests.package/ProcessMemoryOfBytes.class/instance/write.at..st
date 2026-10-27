writing
write: aByteArray at: anAddress

	space bytes replaceFrom: anAddress - space baseAddress + 1 to: anAddress - space baseAddress + aByteArray size with: aByteArray
