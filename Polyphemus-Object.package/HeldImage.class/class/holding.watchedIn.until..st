instance creation
holding: aPid watchedIn: aDirectory until: aMethodSource

	"As holding:watchedIn:within:, then run on to where it reaches that method (#114). Not reached
	within a minute, it is held where it got to."

	| image |
	image := self holding: aPid watchedIn: aDirectory within: 1 minute.
	image runUntil: aMethodSource within: 1 minute.
	^ image