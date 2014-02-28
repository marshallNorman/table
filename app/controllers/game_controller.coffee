App.GameController = Ember.ObjectController.extend
  needs: ['person']
  addGame: (home, away) ->
    console.log "make me a game..."
    newGame = @get('store').createRecord("pendingGame",
      home: home
      away: away
      createdAt: new Date()
    )
    newGame.save()
    @newGame(newGame)

  removeGame: (game) ->
    game.delete()

  newGame: (game) ->
    # Check for a current game
    @get('store').fetch('currentGame').then ((currentGame) =>
      if currentGame.content.length < 1
        @setCurrentGame(game)
    ), (error) =>
      console.log error
  setCurrentGame: (pendingGame) ->
    newRounds = [
      {
        homeScore: 0
        awayScore: 0
      }
    ]
    currentGame = @get('store').createRecord('currentGame',
      home: pendingGame.get('home')
      away: pendingGame.get('away')
      createdAt: pendingGame.get('createdAt')
      startedAt: new Date()
      homeScore: 0
      awayScore: 0
      rounds: newRounds
    )
    # round = @get('store').createRecord("round",
    #   homeScore: 0
    #   awayScore: 0
    # )
    #round.save()
    currentGame.save()
    pendingGame.delete()
    @startGame(currentGame)

  startGame: (currentGame) ->
    #Notify players.
    home = currentGame.get('home')
    away = currentGame.get('away')
   #Tweet

  gameOver: (game) ->
    # Move game to game completed.
