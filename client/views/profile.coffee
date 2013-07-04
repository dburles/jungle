Template.friendList.helpers {
	profileUsername: ->
		user = Meteor.users.findOne Session.get 'profileUserId'
		user.username if user
	
	friends: ->
		friends = Friends.find({ userId: Session.get 'profileUserId' })
		users = []
		friends.forEach (friend) ->
			users.push Meteor.users.findOne(friend.friendId)
		users

	isFriend: ->
		Friends.find({ friendId: @._id, userId: Meteor.userId() }).count() > 0
	
	isUser: ->
		Meteor.userId() is @._id

	hasFriends: ->
		Friends.find({ userId: Session.get 'profileUserId' }).count() > 0

	friendViewingPost: ->
		presence = Meteor.presences.findOne({ userId: @._id })
		if presence
			Jungle.findOne(presence.state.postId)
}

Template.hero.helpers {
	profileUsername: ->
		user = Meteor.users.findOne Session.get 'profileUserId'
		user.username if user
}

Template.friendList.events {
	'click .actionFriend': (event, template) ->
		event.preventDefault()
		filter = { friendId: @._id, userId: Meteor.userId() }
		friend = Friends.findOne filter

		if friend
			friendUser = Meteor.users.findOne(friend.friendId)
			if confirm "Are you sure you want to remove " + friendUser.username + "?"
				Friends.remove friend._id
		else
			Friends.insert filter
			friend = Friends.findOne filter
			friendUser = Meteor.users.findOne(friend.friendId)
			alert "Added " + friendUser.username + " to friends"
}