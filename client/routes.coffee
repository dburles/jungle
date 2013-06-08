Meteor.Router.add {
	'/': 'home',
	'/post/:_id': { to: 'post', and: (id) ->
		Session.set 'id', id
	}
}