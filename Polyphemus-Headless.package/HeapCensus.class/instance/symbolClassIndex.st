naming
symbolClassIndex

	"The class index of #doesNotUnderstand:, in the special objects array (slot 21)."

	^ symbolClassIndex ifNil: [
		  symbolClassIndex := objectMemory classIndexOf: (objectMemory splObj: 20) ]
