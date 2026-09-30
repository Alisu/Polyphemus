initialization
initializePresenters

	roassal := self instantiate: SpRoassalPresenter.
	roassal script: [ :canvas | self buildIn: canvas ]
