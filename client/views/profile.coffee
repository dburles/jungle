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
}