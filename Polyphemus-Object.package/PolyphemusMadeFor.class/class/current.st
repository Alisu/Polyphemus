accessing
current

	"The one host package loaded. None means the baseline has none for this host."

	^ self subclasses
		  ifEmpty: [
			  NotSetUp signal: 'No Polyphemus-Host package is loaded: the baseline has none for '
				  , PolyphemusHost current metacelloAttribute ]
		  ifNotEmpty: [ :all | all first ]
