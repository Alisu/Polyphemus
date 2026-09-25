accessing
oopClass

	"The class the image gives this value, found by its tag as the machine finds it (#42)."

	^ memory reifyOop: (memory fetchClassOf: address)
