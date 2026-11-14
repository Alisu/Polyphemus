building
endOf: aMethod in: aReading

	"The address just past that method's last byte, its trailer's last."

	^ aMethod address + 8 + (aReading numBytesOf: aMethod address)
