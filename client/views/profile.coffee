Template.friendList.helpers {
  profileUsername: ->
    user = Meteor.users.findOne Session.get 'profileUserId'
    user.username if user
  
  friends: ->
    friends = Friends.find { userId: Session.get('profileUserId') }
    Meteor.users.find { _id: { $in: friends.map (user) -> user.friendId }}, sort: { username: 1 }

  isFriend: ->
    Friends.find({ friendId: @._id, userId: Meteor.userId() }).count() > 0
  
  isUser: ->
    Meteor.userId() is @._id

  hasFriends: ->
    Friends.find({ userId: Session.get('profileUserId') }).count() > 0

  friendViewingPost: ->
    presence = Meteor.presences.findOne { userId: @._id, 'state.postId': { $ne: null }}
    if presence
      Jungle.findOne(presence.state.postId)

  friendViewingProfile: ->
    presence = Meteor.presences.findOne { userId: @._id, 'state.profileUserId': { $ne: null } }
    if presence
      Meteor.users.findOne(presence.state.profileUserId)

  status: ->
    presence = Meteor.presences.findOne { userId: @._id }
    if presence
      if presence.state.away
        "away"
      else if presence.focus
        "online-focus"
      else
        "online"
    else
      "offline"
}

Template.hero.helpers {
  profileUsername: ->
    user = Meteor.users.findOne Session.get 'profileUserId'
    user.username if user
}

Template.profileActions.helpers { 
  isFriend: ->
    Friends.find({ friendId: Session.get('profileUserId'), userId: Meteor.userId() }).count() > 0

  isUser: ->
    Meteor.userId() is Session.get 'profileUserId'
}

Template.profileActions.events {
  'click .actionFriend': (event, template) ->
    event.preventDefault()
    actionFriend Session.get 'profileUserId'
}

Template.friendList.events {
  'click .actionFriend': (event, template) ->
    event.preventDefault()
    actionFriend @._id
}

Template.pins.helpers {
  pins: ->
    Pins.find { userId: Session.get('profileUserId') }, sort: { ts: -1 }
}

Template.pinned.helpers {
  post: ->
    Jungle.findOne(@.postId)
}