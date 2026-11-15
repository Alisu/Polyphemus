decoding
decoded: aBlock

	"aBlock's value: Pharo's own decoding of bytes in hand, the source a trailer embeds. Bytes
	Pharo cannot decode are a trailer no image wrote, refused by name."

	^ ForeignCode askingPharo: aBlock ifItFails: [ :undecodable |
		  UnknownFormat signal:
			  'a method trailer whose source does not decode: ' , undecodable messageText asString ]
