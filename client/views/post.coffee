Template.userList.helpers {
  friends: ->
    friends = Friends.find { userId: Meteor.userId() }
    Meteor.users.find { _id: { $in: friends.map (user) -> user.friendId }}, sort: { username: 1 }

  hasFriends: ->
    Friends.find({ userId: Meteor.userId() }).count() > 0

  users: ->
    presences = Meteor.presences.find { 'state.postId': Session.get 'postId' }, sort: { 'state.username': 1 }
    Meteor.users.find({ _id: { $in: presences.map (p) -> p.userId }})

  isFriend: ->
    Friends.find({ friendId: @._id, userId: Meteor.userId() }).count() > 0

  anonymousCount: ->
    Meteor.presences.find({ 'state.postId': Session.get('postId'), userId: { $exists: false }}).count()

  hasAnonymousUsers: ->
    Meteor.presences.find({ 'state.postId': Session.get('postId'), userId: { $exists: false }}).count() > 0

  isUser: ->
    Meteor.userId() is @._id

  friendViewingPost: ->
    presence = Meteor.presences.findOne({ userId: @._id })
    if presence
      Jungle.findOne(presence.state.postId)
}

Template.userList.events {
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

Template.post.helpers {
  post: ->
    Jungle.findOne Session.get 'postId'
}

Template.messages.helpers {
  messages: ->
    Jungle.find { _id: { $not: Session.get 'postId' }, parentId: Session.get 'postId' }, sort: { ts: -1 }
  
  count: ->
    Jungle.find({ _id: { $not: Session.get 'postId' }, parentId: Session.get 'postId' }).count()
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

  'click a#picker': ->
    if signedIn()
      filepicker.pick {},
        (FPFile) ->
          Session.set 'file', FPFile
        (FPError) ->
          
  'click a#removeFile': ->
    filepicker.remove Session.get 'file'
    Session.set 'file', null
    false
}

signedIn = ->
  if not Meteor.user()
    alert "Please sign-in first"
    return false
  return true