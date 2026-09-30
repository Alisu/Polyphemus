tests
testAnObjectCoversThePixelsItsBytesFallIn

	"Bytes 12 to 35: pixels 1 (8-15) to 4 (32-39)."

	self assert: (map pixelsOf: 16r1000 + 12 size: 24) equals: (1 to: 4)
