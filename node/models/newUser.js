var mongoose = require('mongoose');

var newUserSchema = mongoose.Schema({
     name: String,
        surname: String,
        email : String,
        number : Number,
        currency : String

})

var newUser = mongoose.model('newUser', newUserSchema);
module.exports = newUser