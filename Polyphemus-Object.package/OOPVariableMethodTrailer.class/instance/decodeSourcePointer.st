decoding
decodeSourcePointer

	| last |
	last := bytes size.
	size := 4.
	data := (bytes at: last) - 251 << 8 + (bytes at: last - 1) << 8 + (bytes at: last - 2) << 8
	        + (bytes at: last - 3)
