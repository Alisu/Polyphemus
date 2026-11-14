private
stream

	"The dump file itself, opened when first wanted, not a buffered stream over it; and opened
	again when the one held is closed, as the stream of a reading saved with an image is (#197)."

	(stream isNil or: [ stream closed ]) ifTrue: [
		stream := (File named: file asFileReference fullName) openForRead ].
	^ stream
