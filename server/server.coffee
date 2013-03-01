Jungle = new Meteor.Collection "jungle"

Meteor.publish "jungle", (parent_id) ->
	Jungle.find({ $or: [{ parent_id: parent_id }, { _id: parent_id }] }, limit: 100)

#Meteor.publish "jungle": ->
#	Jungle.find {}

Meteor.startup ->
	if Jungle.find().count() == 0
		user_id = Accounts.createUser {
			username: "dave",
			email: "dburles@gmail.com",
			password: "password",
		}

		Jungle.insert {
			user_id: user_id,
			name: "dave",
			message: "Hello World!",
			message_count: 0,
			ts: Date.parse(new Date),
		}

Jungle.allow {
	insert: ->
		true
	update: ->
		true
	remove: ->
		false
}
