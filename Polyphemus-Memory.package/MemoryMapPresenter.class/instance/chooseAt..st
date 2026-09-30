events
chooseAt: aPoint

	(self picture objectAt: aPoint floor) ifNotNil: [ :address | chosenBlock value: address ]
