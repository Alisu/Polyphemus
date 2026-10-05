restarting
targetLogIn: aFile

	^ [ aFile contents ] on: Error do: [ :e | nil ]
