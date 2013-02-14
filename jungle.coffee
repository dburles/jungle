
Meteor.autorun ->
	Meteor.subscribe 'jungle', { parent_id: Session.get('id') }

Jungle = new Meteor.Collection "jungle"

if Meteor.isClient

	Template.

	Template.messages.messages = -> 
		#if Session.get('id')
		#	Jungle.find { parent_id : Session.get('id') }, sort: { ts: -1 }
		#else
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
						ts: Date.parse new Date,
					}
				else
					Jungle.insert {
						name: name,
						message: $('input#message').val(),
						ts: Date.parse new Date
					}

				$('input#message').val("")
	}

	JungleRouter = Backbone.Router.extend {
		routes: { ':id': 'main' },
		main: (id) ->
			message = Jungle.findOne { _id : message._id }
			Session.set 'id', id if message
	}

	Router = new JungleRouter



###
	Template.messages.messages
		if (id in url)

			return data where parent_id = ( example.com/(id) )

	Template.form.events 
		if (id in url)
			
			insert { parent_id: id }
	
###
