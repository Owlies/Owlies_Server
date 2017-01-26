local mongo = require('mongo')

local client = mongo.Client 'mongodb://0.0.0.0:29000'
local database = client:getDatabase('towergirl')
local collection = database:getCollection('user_account')

local query = mongo.BSON '{ "user_id" : { "$gt" : "0" } }'

for document in collection:find(query):iterator() 
do
    print(document.user_id, document.account, document.device, document.facebook_account, document.google_play_account, document.identifier)
end


