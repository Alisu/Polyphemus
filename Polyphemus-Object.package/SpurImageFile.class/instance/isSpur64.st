testing
isSpur64

	"68021 is a 64-bit Spur image; 68533 the same with the Sista bytecodes flag."

	^ header size = 88 and: [ #( 68021 68533 ) includes: self version ]
