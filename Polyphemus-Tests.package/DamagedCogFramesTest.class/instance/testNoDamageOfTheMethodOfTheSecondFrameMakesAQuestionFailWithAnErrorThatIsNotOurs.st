tests
testNoDamageOfTheMethodOfTheSecondFrameMakesAQuestionFailWithAnErrorThatIsNotOurs

	"Measured on 2026-11-16 (#118): damaged word for word, the second frame answers as the middle
	one does, but for its method. So only that word of it is damaged."

	self assertEveryQuestionIsAnsweredOrRefusedByNameWithTheFrameDamagedAt: 2 inWords: #( 'word -8' )
