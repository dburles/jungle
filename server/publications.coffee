Meteor.publish 'userPresence', (postId) ->
	# Setup some filter to find the users your logged in user
	# cares about. It's unlikely that you want to publish the 
	# presences of _all_ the users in the system.
	

  # filter = { 'state.postId': postId }
  # filter = { 'state.postId': postId, 'userId': { $in: friends.map(function(friend) { return friend.friendId } }}

	# ProTip: unless you need it, don't send lastSeen down as it'll make your 
	# templates constantly re-render (and use bandwidth)
	Meteor.presences.find {}, { fields: { state: true, userId: true }}


# Meteor.publish 'jungle', ->
# 	Jungle.find {}

# Meteor.publish 'jungle', (parentId) ->
	# Jungle.find { $or: [{ parentId: parentId }, { _id: parentId }] }, limit: 100

Meteor.publish 'jungle', (parentId) ->
  Jungle.find()


Meteor.publish 'directory', ->
	Meteor.users.find()

Meteor.publish 'friends', (userId) ->
  Friends.find { userId: userId }

# Meteor.publish 'directory', (postId) ->
# 	presences = Meteor.presences.find { 'state.postId': postId }
# 	Meteor.users.find { _id: { $in: presences.map (p) -> p.userId }}, { fields: { username: true, profile: true }}