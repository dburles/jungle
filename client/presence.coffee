Session.setDefault('browserFocus', true);

Meteor.Presence.state = ->
  # console.log('presence tick')
  {
    online: true
    username: if Meteor.user() then Meteor.user().username else "Anonymous"
    postId: Session.get 'postId'
    profileUserId: Session.get 'profileUserId'
    away: Session.get 'away'
    focus: Session.get('browserFocus')
    # currentTypingPostId: Session.get 'currentTypingPostId'
  }

Meteor.startup ->
  window.onfocus = ->
    Session.set('browserFocus', true);

  window.onblur = ->
    Session.set('browserFocus', false);
