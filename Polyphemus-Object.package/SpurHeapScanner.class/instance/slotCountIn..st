reading headers
slotCountIn: aHeader

	"The top byte. 255 means the real count is in the word before."

	^ aHeader bitShift: -56
