Meteor.methods {
	addMessage: (attrs) ->
		data = _.extend(_.pick(attrs, 'parentId', 'message', 'file'), {
			userId: Meteor.userId()
			username: Meteor.presences.findOne({ userId: Meteor.userId() }).state.username
			messageCount: 0
			ts: (new Date).getTime()
		})

		Jungle.insert data
		Jungle.update { _id: attrs.parentId }, { $inc: { messageCount: 1 } }
}