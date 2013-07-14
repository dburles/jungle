Template.userList.helpers {
  friends: ->
    friends = Friends.find { userId: Meteor.userId() }
    Meteor.users.find { _id: { $in: friends.map (user) -> user.friendId }}, sort: { username: 1 }

  hasFriends: ->
    Friends.find({ userId: Meteor.userId() }).count() > 0

  users: ->
    presences = Meteor.presences.find { 'state.postId': Session.get('postId') }, sort: { 'state.username': 1 }
    Meteor.users.find({ _id: { $in: presences.map (p) -> p.userId }})

  anonymousCount: ->
    Meteor.presences.find({ 'state.postId': Session.get('postId'), userId: { $exists: false }}).count()

  hasAnonymousUsers: ->
    Meteor.presences.find({ 'state.postId': Session.get('postId'), userId: { $exists: false }}).count() > 0

  isUser: ->
    Meteor.userId() is @._id

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
    actionFriend @._id
}

Template.post.helpers {
  post: ->
    Jungle.findOne Session.get 'postId'
}

Template.messagePane.helpers {
  messagePaneHidden: ->
    Session.get 'messagePaneHidden'
}

Template.postActions.helpers { 
  isPinned: ->
    Pins.find({ postId: Session.get('postId'), userId: Meteor.userId() }).count() > 0

  isFriend: ->
    post = Jungle.findOne Session.get 'postId'
    if post
      Friends.find({ friendId: post.userId, userId: Meteor.userId() }).count() > 0

  isUser: ->
    post = Jungle.findOne Session.get 'postId'
    if post
      Meteor.userId() is post.userId

  post: ->
    Jungle.findOne Session.get 'postId'
}

Template.postActions.events {
  'click .actionPin': (event, template) ->
    event.preventDefault()
    actionPin Session.get 'postId'

  'click .actionFriend': (event, template) ->
    event.preventDefault()
    post = Jungle.findOne Session.get 'postId'
    actionFriend post.userId
}

Template.messages.helpers {
  messages: ->
    Jungle.find { _id: { $not: Session.get('postId') }, parentId: Session.get('postId') }, sort: { ts: 1 }
  
  count: ->
    Jungle.find({ _id: { $not: Session.get('postId') }, parentId: Session.get('postId') }).count()
}

Template.message.helpers {
  userCount: ->
    Meteor.presences.find({ 'state.postId': @._id }).count()

  isPinned: ->
    Pins.find({ postId: @._id, userId: Meteor.userId() }).count() > 0
}

Template.post.events {
  'click .message-tab': ->
    if Session.get 'messagePaneHidden'
      # $('.messages').show();
      # $('.messageForm').show();
      # $('.message-pane').css('width', '50%');
      Session.set 'messagePaneHidden', false
    else
      # $('.messages').hide();
      # $('.messageForm').hide();
      # $('.message-pane').css('width', '0');
      Session.set 'messagePaneHidden', true
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
        resetAwayTimer()

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

Template.message.rendered = ->
  # shouldScroll = $('.messages').scrollTop() + $('.messages').height() == $('#messages').height()
  # if (shouldScroll)
  $('.messages').scrollTop(9999999)

