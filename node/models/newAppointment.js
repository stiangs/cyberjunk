var mongoose = require('mongoose');

var newAppointmentSchema = mongoose.Schema({
        settlementId :String,
        name : String,
        attendees: [String],
        punishment : Number,
        currency : String,
	    lat: String,
        lon: String,
	    date : String,
        meetup: [String]

}
)

var newAppointment = mongoose.model('newAppointment', newAppointmentSchema);
module.exports = newAppointment