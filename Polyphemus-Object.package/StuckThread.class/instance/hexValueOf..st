reading
hexValueOf: aString

	^ Number readFrom: (aString copyReplaceAll: '0x' with: '') base: 16
