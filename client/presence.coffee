Meteor.Presence.state = ->
  # console.log('presence tick')
  {
    online: true
    username: if Meteor.user() then Meteor.user().username else "Anonymous"
    postId: Session.get 'postId'
    profileUserId: Session.get 'profileUserId'
    away: Session.get 'away'
    # currentTypingPostId: Session.get 'currentTypingPostId'
  }