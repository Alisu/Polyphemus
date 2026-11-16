reading
checkedInterpreterOnImageFile: aPath

	"An image file opened in the simulator and not started, after the ladder's rungs it must
	climb to be read (#readabilityOfImageFile:): refused below them, with the level and the reason."

	| readability |
	readability := self readabilityOfImageFile: aPath.
	#( #bytes #heap #objects #classes ) do: [ :each | readability require: each ].
	^ self interpreterOnImageFile: aPath
