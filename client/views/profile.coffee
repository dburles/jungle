Template.friendList.helpers {
  profileUsername: ->
    user = Meteor.users.findOne Session.get 'profileUserId'
    user.username if user
  
  friends: ->
    friends = Friends.find { userId: Session.get 'profileUserId' }
    Meteor.users.find { _id: { $in: friends.map (user) -> user.friendId }}, sort: { username: 1 }

  isFriend: ->
    Friends.find({ friendId: @._id, userId: Meteor.userId() }).count() > 0
  
  isUser: ->
    Meteor.userId() is @._id

  hasFriends: ->
    Friends.find({ userId: Session.get 'profileUserId' }).count() > 0

  friendViewingPost: ->
    presence = Meteor.presences.findOne { userId: @._id }
    if presence
      Jungle.findOne(presence.state.postId)
  
  status: ->
    presence = Meteor.presences.findOne { userId: @._id }
    if presence
      "online"
    else
      "offline"
}

Template.hero.helpers {
  profileUsername: ->
    user = Meteor.users.findOne Session.get 'profileUserId'
    user.username if user
}

Template.friendList.events {
  'click .actionFriend': (event, template) ->
    event.preventDefault()
    if signedIn()
      filter = { friendId: @._id, userId: Meteor.userId() }
      friend = Friends.findOne filter

      if friend
        friendUser = Meteor.users.findOne(friend.friendId)
        if confirm "Are you sure you want to remove " + friendUser.username + "?"
          Friends.remove friend._id
          $.bootstrapGrowl "You are no longer friends with " + friendUser.username
      else
        Friends.insert filter
        friend = Friends.findOne filter
        friendUser = Meteor.users.findOne(friend.friendId)
        $.bootstrapGrowl "Added " + friendUser.username + " to friends", { type: 'success' }
}

Template.pins.helpers {
  pins: ->
    Pins.find { userId: Session.get 'profileUserId' }, sort: { ts: -1 }
}

Template.pinned.helpers {
  post: ->
    Jungle.findOne(@.postId)
}