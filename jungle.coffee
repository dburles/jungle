
#Meteor.autorun ->

#Meteor.subscribe 'jungle', -> 
#	if Session.get('id')
#		messages = { parent_id: Session.get('id') }

Jungle = new Meteor.Collection "jungle"

if Meteor.isClient
	Template.top.parent = ->
		if Session.get('id')
			Jungle.findOne { _id : Session.get('id') }

	Template.messages.messages = ->
		if Session.get('id')
			Jungle.find { parent_id : Session.get('id') }, sort: { ts: -1 }
		else
			Jungle.find {}, sort: { ts: -1 }

	Template.top.events {
		'click a#gotoparent' : ->
			Session.set 'id', $('a#gotoparent').attr('href')
			$('input#message').focus()
	}
	
	Template.messages.events {
		'click a' : -> $('input#message').focus()
	}

	Template.form.events {
		'keypress input#message' : (e) ->
			if e.which is 13

				if Meteor.user()
					name = Meteor.user().username
				else
					name = "Anonymous"
				
				if Session.get('id') 
					Jungle.insert {
						parent_id: Session.get('id'),
						image: $('input#image').val(),
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
						ts: Date.parse new Date,
					}

				$('input#image').val("")
				$('input#message').val("")
	}

	Meteor.Router.add {
		'' : -> Session.set 'id', null
		'/:id' : (id) ->
			message = Jungle.findOne { _id : id }
			Session.set 'id', id if message
	}

	Accounts.ui.config {
		passwordSignupFields: 'USERNAME_AND_EMAIL'
	}

if Meteor.isServer
	Meteor.startup ->
		if Jungle.find().count() == 0
			user_id = Accounts.createUser {
				username: 'dave',
				email: 'dburles@gmail.com',
				password: 'password',
			}

			Jungle.insert {
				user_id: user_id,
				name: 'dave',
				message: 'Hello World!',
				message_count: 0,
				ts: Date.parse new Date,
			}

