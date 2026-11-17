holding it still
isQuietOrLetGo

	"Whether it is quiet, asked while stopped: let go before the refusal shows when that does not
	read, or it would stay stopped (#181)."

	| quiet |
	[ quiet := self isQuiet ] valueThenLetGo: [ quiet ifNil: [ self resume ] ].
	^ quiet
