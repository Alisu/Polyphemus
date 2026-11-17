helpers
aHoldThatIsNotTaken

	| image |
	image := HeldImageWhoseHoldIsNotTaken new.
	^ image setReader: image directory: directory; yourself
