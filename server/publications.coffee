Meteor.publish 'userPresence', ->
	# Setup some filter to find the users your logged in user
	# cares about. It's unlikely that you want to publish the 
	# presences of _all_ the users in the system.
	filter = {}

	# ProTip: unless you need it, don't send lastSeen down as it'll make your 
	# templates constantly re-render (and use bandwidth)
	Meteor.presences.find filter, {fields: {state: true, userId: true}}


Meteor.publish 'jungle', ->
	Jungle.find {}


#Meteor.publish "jungle", (parent_id) ->
#	Jungle.find({ $or: [{ parent_id: parent_id }, { _id: parent_id }] }, limit: 100)

#Meteor.publish "jungle": ->
#	Jungle.find {}