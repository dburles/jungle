Meteor.Router.beforeRouting = ->
  resetAwayTimer()

Meteor.Router.add {
  '/': 'home'
  '/post/:_id': {
    to: 'post'
    and: (id) ->
      Session.set 'postId', id
  }
  '/profile/:_id': {
    to: 'profile'
    and: (id) ->
      Session.set 'profileUserId', id
  }
}