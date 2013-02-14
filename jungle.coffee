
#Meteor.autorun ->

#Meteor.subscribe 'jungle', -> 
#	if Session.get('id')
#		messages = { parent_id: Session.get('id') }

Jungle = new Meteor.Collection "jungle"

if Meteor.isClient

	Template.parent.parent = ->
		if Session.get('id')
			Jungle.findOne { _id : Session.get('id') }

	Template.messages.messages = -> 
		if Session.get('id')
			Jungle.find { parent_id : Session.get('id') }, sort: { ts: -1 }
		else
			Jungle.find {}, sort: { ts: -1 }

	Template.form.events {
		'keypress input#message' : (e) ->
			if e.which is 13

				if $('input#name').val()
					name = $('input#name').val()
				else
					name = "Anonymous"
				
				if Session.get('id') 
					Jungle.insert {
						parent_id: Session.get('id'),
						name: name,
						message: $('input#message').val(),
						message_count: 0,
						ts: Date.parse new Date,
					}
					Jungle.update { _id: Session.get('id') }, { $inc: { message_count: 1 } }
				else
					Jungle.insert {
						name: name,
						message: $('input#message').val(),
						message_count: 0,
						ts: Date.parse new Date
					}

				$('input#message').val("")
	}

	Meteor.Router.add {
		'' : -> Session.set 'id', null
		'/:id' : (id) ->
			message = Jungle.findOne { _id : id }
			Session.set 'id', id if message
	}



###
	Template.messages.messages
		if (id in url)

			return data where parent_id = ( example.com/(id) )

	Template.form.events 
		if (id in url)
			
			insert { parent_id: id }
	
###
