Meteor.Router.beforeRouting = ->
  resetAwayTimer()

Meteor.Router.add {
  '/':
    to: 'home'
    and: ->
      Session.set 'profileUserId', null
      Session.set 'postId', null
      
  '/post/:_id':
    to: 'post'
    and: (id) ->
      Session.set 'profileUserId', null
      Session.set 'postId', id
  
  '/profile/:_id': 
    to: 'profile'
    and: (id) ->
      Session.set 'postId', null
      Session.set 'profileUserId', id
  
}