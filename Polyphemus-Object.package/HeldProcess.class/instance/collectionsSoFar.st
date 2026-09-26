private
collectionsSoFar

	"How many times the image has collected garbage, scavenges and full: while the count stays,
	nothing it holds has moved. The process must be stopped."

	| variables |
	variables := VMVariables on: reader.
	^ (variables at: 'statScavenges') -> (variables at: 'statFullGCs')
