private
stream

	"The open read stream on the dump, opened when first wanted."

	^ stream ifNil: [ stream := file binaryReadStream ]
