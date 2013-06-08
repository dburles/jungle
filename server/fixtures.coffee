Meteor.startup ->
	if Jungle.find().count() is 0
		userId = Accounts.createUser {
			username: "dave",
			email: "dburles@gmail.com",
			password: "password",
		}

		Jungle.insert {
			userId: userId,
			username: "dave",
			message: "Hello World!",
			messageCount: 0,
			ts: (new Date).getTime(),
		}