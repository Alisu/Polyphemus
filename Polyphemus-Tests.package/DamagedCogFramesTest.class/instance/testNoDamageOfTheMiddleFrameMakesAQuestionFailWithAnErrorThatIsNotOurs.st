tests
testNoDamageOfTheMiddleFrameMakesAQuestionFailWithAnErrorThatIsNotOurs

	self assertEveryQuestionIsAnsweredOrRefusedByNameWithTheFrameDamagedAt: (self frames size + 1 // 2)
