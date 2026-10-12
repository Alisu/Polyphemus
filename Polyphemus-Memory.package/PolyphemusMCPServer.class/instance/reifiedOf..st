tools
reifiedOf: anImage

	"An image file's objects, reified when first asked for; a core's, when it was opened."

	^ (anImage at: #reified ifAbsent: [ nil ]) ifNil: [
		  anImage at: #reified put: (FullyReifiedMemory on: (anImage at: #memory)) ]
