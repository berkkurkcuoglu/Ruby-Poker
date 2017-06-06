Player --> class to hold player stats
Hand --> Hand of cards
Table --> table class to keep track of players and actions uses enumerable module
Card	--> class to create cards with value and suit attributes
Deck	--> class to have a set of cards,  uses enumerable module

APIProxy	--> abstract api proxy class to make api calls
PokerOddsProxy --> concrete class inherits apiproxy and gets odds using StevenMoore's API
UserDataProxy	--> concrete class inherits apiproxy and gets name from randomusergenerating api

Style	--> style interface for user play styles
TightAggressive	--> concrete style class for tight aggressive players
TightPassive --> concrete style class for tight passive players
LooseAggressive --> concrete style class for loose aggressive players
LoosePassive --> concrete style class for loose passive players

Database --> database class to read from and write to a flat database file consisting of JSON data
data.json --> flat database file for read and write operations

main --> driver code to simulate the game
