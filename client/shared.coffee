@actionFriend = (userId) ->
  if signedIn()
    filter = { friendId: userId, userId: Meteor.userId() }
    friend = Friends.findOne filter

    if friend
      friendUser = Meteor.users.findOne(friend.friendId)
      if confirm "Are you sure you want to unfriend " + friendUser.username + "?"
        Friends.remove friend._id
        $.bootstrapGrowl "You are no longer friends with " + friendUser.username
    else
      Friends.insert filter
      friend = Friends.findOne filter
      friendUser = Meteor.users.findOne(friend.friendId)
      $.bootstrapGrowl "Added " + friendUser.username + " to friends", { type: 'success' }

@actionPin = (postId) ->
  if signedIn()
    filter = { postId: postId, userId: Meteor.userId() }
    pin = Pins.findOne filter
    
    if pin
      post = Jungle.findOne(pin.postId)
      user = Meteor.users.findOne(post.userId)
      Pins.remove pin._id
      $.bootstrapGrowl "Unpinned " + user.username + "'s message"
    else
      Pins.insert _.extend(filter, { ts: (new Date).getTime() })
      pin = Pins.findOne filter
      post = Jungle.findOne(pin.postId)
      user = Meteor.users.findOne(post.userId)
      $.bootstrapGrowl "Pinned " + user.username + "'s message to your profile", { type: 'success' }