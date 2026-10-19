private
whyNotServing

	"What the watcher left when the agent's script failed (do-failed, beside this directory),
	or nothing."

	| failed |
	failed := directory parent / 'do-failed'.
	failed exists ifFalse: [ ^ '' ].
	^ ': the image could not run the agent (' , ([ failed contents trimBoth ] on: Error do: [ :e | '' ]) , ')'
