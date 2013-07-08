Template.userList.helpers {
  friends: ->
    friends = Friends.find { userId: Meteor.userId() }
    Meteor.users.find { _id: { $in: friends.map (user) -> user.friendId }}, sort: { username: 1 }

  hasFriends: ->
    Friends.find({ userId: Meteor.userId() }).count() > 0

  users: ->
    presences = Meteor.presences.find { 'state.postId': Session.get 'postId' }, sort: { 'state.username': 1 }
    Meteor.users.find({ _id: { $in: presences.map (p) -> p.userId }})

  anonymousCount: ->
    Meteor.presences.find({ 'state.postId': Session.get('postId'), userId: { $exists: false }}).count()

  hasAnonymousUsers: ->
    Meteor.presences.find({ 'state.postId': Session.get('postId'), userId: { $exists: false }}).count() > 0

  isUser: ->
    Meteor.userId() is @._id

  friendViewingPost: ->
    presence = Meteor.presences.findOne { userId: @._id }
    if presence
      presence = Jungle.findOne(presence.state.postId)

  status: ->
    presence = Meteor.presences.findOne { userId: @._id }
    if presence
      if presence.state.away
        "away"
      else
        "online"
    else
      "offline"

}

Handlebars.registerHelper 'displayCount', (count) ->
  if count > 1000 then "1000+" else count

Template.userList.events {
  'click .actionFriend': (event, template) ->
    event.preventDefault()
    if signedIn()
      filter = { friendId: @._id, userId: Meteor.userId() }
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
}

Template.post.helpers {
  post: ->
    Jungle.findOne Session.get 'postId'
}

Template.messages.helpers {
  messages: ->
    Jungle.find { _id: { $not: Session.get 'postId' }, parentId: Session.get 'postId' }, sort: { ts: 1 }
  
  count: ->
    Jungle.find({ _id: { $not: Session.get 'postId' }, parentId: Session.get 'postId' }).count()
}

Template.message.helpers {
  userCount: ->
    Meteor.presences.find({ 'state.postId': @._id }).count()

  isPinned: ->
    Pins.find({ postId: @._id, userId: Meteor.userId() }).count() > 0
}

Template.messageForm.helpers {
  fileReady: ->
    Session.get 'file'

  # typingPresences: ->
  #   Meteor.presences.find { userId: { $ne: Meteor.userId() }, 'state.currentTypingPostId': @._id }
}

Template.messageForm.events {
  # 'keyup input[name="message"]': (event, template) ->
  #   Session.set 'typing', if template.find('input[name="message"]').value then true else false

  'submit form': (event, template) ->
    event.preventDefault()
    
    if signedIn()
      message = template.find 'input[name=message]'

      if message.value
        Meteor.call 'addMessage', {
          _id: Random.id() # fix for client/server id bug
          parentId: Session.get 'postId'
          message: message.value
          file: Session.get 'file'
        }
        Session.set 'file', null
        event.target.reset()
        setAwayTimeout()

  'click a#picker': ->
    if signedIn()
      filepicker.pick {},
        (FPFile) ->
          Session.set 'file', FPFile
          $.bootstrapGrowl "Your image is ready to post!"
        (FPError) ->
          
  'click a#removeFile': ->
    filepicker.remove Session.get 'file'
    Session.set 'file', null
    false
}

Template.message.events {
  'click .actionPin': (event, template) ->
    event.preventDefault()
    if signedIn()
      filter = { postId: @._id, userId: Meteor.userId() }
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
}

Template.message.rendered = ->
  # shouldScroll = $('.messages').scrollTop() + $('.messages').height() == $('#messages').height()
  # if (shouldScroll)
  $('.messages').scrollTop(9999999)

