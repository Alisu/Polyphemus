tests
testNoDamageOfWhereTheSchedulerIsKeptMakesAQuestionFailWithAnErrorThatIsNotOurs

	"The slot of the special objects that holds the scheduler's association."

	subject := reifiedMemory reifiedSpecialObjectArray.
	self assertEveryQuestionIsAnsweredOrRefusedByNameWithSlotsDamaged: { reifiedMemory processes schedulerAssociationSlot }
