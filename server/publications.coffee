Meteor.publish 'userPresence', ->
  # Setup some filter to find the users your logged in user
  # cares about. It's unlikely that you want to publish the 
  # presences of _all_ the users in the system.
  
  # ProTip: unless you need it, don't send lastSeen down as it'll make your 
  # templates constantly re-render (and use bandwidth)
  Meteor.presences.find {}, { fields: { state: true, focus: true, userId: true }}

Meteor.publish 'jungle', ->
  Jungle.find {}

Meteor.publish 'directory', ->
  Meteor.users.find {}

Meteor.publish 'friends', ->
  Friends.find {}

Meteor.publish 'pins', ->
  Pins.find {}