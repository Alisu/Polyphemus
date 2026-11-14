decoding
decoded: aBlock

	"aBlock's value: Pharo's own decoding of the source a trailer embeds. Bytes it cannot
	decode are a trailer no image wrote, refused by name."

	^ aBlock
		  on: Error
		  do: [ :undecodable |
			  UnknownFormat signal:
				  'a method trailer whose source does not decode: ' , undecodable messageText asString ]
