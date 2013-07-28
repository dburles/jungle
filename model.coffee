@Jungle = new Meteor.SmartCollection 'jungle'
@Friends = new Meteor.SmartCollection 'friends'
@Pins = new Meteor.SmartCollection 'pins'

Jungle.allow {
  insert: ->
    true
  update: ->
    true
  remove: ->
    false
}
Friends.allow {
  insert: ->
    true
  update: ->
    true
  remove: ->
    true
}
Pins.allow {
  insert: ->
    true
  update: ->
    true
  remove: ->
    true
}

Meteor.methods {
  addMessage: (attrs) ->
    data = _.extend(_.pick(attrs, '_id', 'parentId', 'message', 'file'), {
      userId: Meteor.userId()
      username: Meteor.presences.findOne({ userId: Meteor.userId() }).state.username
      messageCount: 0
      ts: (new Date).getTime()
    })

    Jungle.insert data
    Jungle.update { _id: attrs.parentId }, { $inc: { messageCount: 1 } }
  
  addFriend: (attrs) ->
    data = _.extend(_.pick(attrs, 'friendId'), {
      userId: Meteor.userId()
      ts: (new Date).getTime()
    })

    Friends.insert data  
}