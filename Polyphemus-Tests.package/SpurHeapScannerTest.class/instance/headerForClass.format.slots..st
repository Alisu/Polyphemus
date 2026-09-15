building a heap
headerForClass: aClassIndex format: aFormat slots: aSlotCount

	"Class index in bits 0 to 21, format in 24 to 28, slot count in the top byte."

	^ (aSlotCount bitShift: 56) + (aFormat bitShift: 24) + aClassIndex
