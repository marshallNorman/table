module.exports = App.PeopleController = Ember.ArrayController.extend
  needs: ['auth', 'challenge']
  person: Ember.computed.alias('controllers.auth.person')
  errors: []
  personName: null
  personEmail: null
  people: (->
    currentPerson = @get('person')
    people = @get('content').map((person) =>
      isMe = ( person.get('id') == currentPerson?.get('id') )
      person.set('isMe', isMe)
      person
    )
    Em.ArrayProxy.createWithMixins(
      Ember.SortableMixin,
        content: people
        sortProperties: ['wins']
        sortAscending: false
    )
  ).property('content.@each', 'person')
  isChallenged: (person) ->
    challenges = @get('challenges_away')
    challenges.map (challenge) =>
      if challenge.get('away.id') == person.get('id')
        person.set('challengedBy', challenge.get('home'))
        person.set('isChallenged', true)
        @set('person', person)
  actions:
    addPerson: ->
      personName = @get('personName')
      personEmail = @get('personEmail')
      errors = @get('errors')
      errors = []
      if personName == undefined or personName == "" or personName == null
        errors.push "Person name empty."
      if personEmail == undefined or personEmail == "" or personEmail== null
        errors.push "Person email empty."
      if errors.length < 1
        person = @store.createRecord("person",
          name: personName
          email: personEmail
        )
        person.save()
        @set('isAdding', false)
        @set('personName', null)
        @set('personEmail', null)
      else
        @set('errors', errors)

    showAddPerson: ->
      @set('isAdding', true)
    cancelAddPerson: ->
      @set('isAdding', false)
      @set('errors', [])
      @set('personName', null)
      @set('personEmail', null)
      
  isAdding: false
