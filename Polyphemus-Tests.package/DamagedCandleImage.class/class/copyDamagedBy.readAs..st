building
copyDamagedBy: someWords readAs: aCleanReading

	"A copy of the Candle file, in the temporary directory, damaged by someWords."

	^ self
		  copyOf: self cleanFile
		  damagedBy: someWords
		  readAs: aCleanReading
		  to: FileLocator temp asFileReference / ('polyphemus-damaged-candle-' , UUID new asString , '.image')
