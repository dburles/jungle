Jungle = new Meteor.Collection "jungle"

Jungle.allow {
	insert: ->
		true
	update: ->
		true
	remove: ->
		false
}
