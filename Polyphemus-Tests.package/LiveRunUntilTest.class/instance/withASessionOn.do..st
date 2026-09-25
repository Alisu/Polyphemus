helpers
withASessionOn: aPid do: aBlock

	"A session holding that image, handed to aBlock; the image killed afterwards."

	[ aBlock value: (Polyphemus holdProcess: aPid watchedIn: self spikeDirectory) ] ensure: [
		LibC system: 'kill -9 ' , aPid printString ]
