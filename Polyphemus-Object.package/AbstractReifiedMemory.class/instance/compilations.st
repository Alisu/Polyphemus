highlighting
compilations

	"The image's code compiled here and matched to its methods (HostCompilations)."

	^ compilations ifNil: [ compilations := HostCompilations on: self ]
