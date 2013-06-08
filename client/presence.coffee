Meteor.Presence.state = ->
	{
		online: true
		username: if Meteor.user() then Meteor.user().username else "Anonymous"
		postId: Session.get 'postId'
	}