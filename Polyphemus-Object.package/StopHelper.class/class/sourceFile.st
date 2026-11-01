accessing
sourceFile

	^ [ (IceRepository registeredRepositoryIncludingPackage:
		     (self packageOrganizer packageNamed: 'Polyphemus-Object')) location / 'bin' / 'polyphemus-stop.c' ]
		  on: Error
		  do: [ :error | nil ]
