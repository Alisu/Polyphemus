private
stream

	"The dump file itself, opened when first wanted, not a buffered stream over it."

	^ stream ifNil: [ stream := (File named: file asFileReference fullName) openForRead ]
