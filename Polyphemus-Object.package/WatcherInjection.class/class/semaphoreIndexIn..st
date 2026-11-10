semaphore index
semaphoreIndexIn: aDirectory

	"Where the watcher of aDirectory registered its semaphore; nil when none left its index there.
	A file holding no index is refused: a watcher being set up, or one whose setup was cut."

	| file text |
	file := aDirectory / 'semaphore-index'.
	file exists ifFalse: [ ^ nil ].
	text := file contents trimBoth.
	(text notEmpty and: [ text isAllDigits ]) ifFalse: [
		^ HoldFailed signal: file fullName , ' holds no index: a watcher is being set up there, or its setup was cut' ].
	^ text asNumber
