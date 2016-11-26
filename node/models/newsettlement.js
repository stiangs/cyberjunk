var mongoose = require('mongoose');

var newSettlementSchema = mongoose.Schema({
    appointmentId: String,
    summary: [],
    setteled : Boolean

}
)

var newSettlement = mongoose.model('newSettlement', newSettlementSchema);
module.exports = newSettlement