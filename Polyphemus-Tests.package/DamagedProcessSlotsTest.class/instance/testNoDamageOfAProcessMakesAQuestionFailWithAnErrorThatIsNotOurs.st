tests
testNoDamageOfAProcessMakesAQuestionFailWithAnErrorThatIsNotOurs

	subject := process.
	self assertEveryQuestionIsAnsweredOrRefusedByNameWithSlotsDamaged: (1 to: subject oopNumberOfSlots)
