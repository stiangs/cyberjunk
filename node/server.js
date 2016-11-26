var http = require('http')
var credentials = require('./credentials.js');
var express = require('express')
var app = express()
var mUser = require('./models/newUser')
var mSettlement = require('./models/newsettlement')
var db = require('mongoose');
var mAppointment = require('./models/newAppointment')
app.set('port', process.env.PORT || 3000);
db.Promise = require('bluebird');
app.use(require('body-parser').urlencoded({extended:true}));
var bodyParser = require('body-parser');


var opts  = {
    server:{
        socketOptions : {keepAlive: 1}
    }
};

app.use(bodyParser.json());
//Adding user 
/*
POST xxx/adduser 


JSON: 


{ "person":{
    "name": "string",
    "surname" : "string",
    "email" : "string",
    "number" : "phonenumber",
    "currency" : "String"
}
} 
*/

app.post('/users/:phonenumber/newappointment', function(req, res){

    console.log(req.body)

    var meetUp = []
    
    var appointment = new mAppointment({
        settlementId : "",
        name : req.body.name,
        lat: req.body.lat,
        lon: req.body.lon,
        date : req.body.date,
        punishment : req.body.punishment,
        currency : req.body.currency,
        attendees : req.body.attendees,
        meetup : meetUp, 
        dos : false
    });

     appointment.save(function(err, appointment ){
        if(err) return res.status(500).send('error, dbError. ');
        res.json({id: appointment._id});
    }) 
})



//////////////////////////////////////////////////////////
/* Retriving appointments by phonenumber
*/


app.get('/:phonenumber/appointment', function (req, res){
    //gives all relevant appointments for the spesific number
        var number = (req.params.phonenumber).toString()
        
        mAppointment.find({attendees:number},function(err, appoint) {
            if (err){
                res.send(err);
            }
            console.log(appoint)
            res.json(appoint);
        });
    });

////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////
app.get('/users/:id', function(req, res){
    mUser.findById(req.params.id, function(err, a){
     if(err){
        res.send(err)
     }
     else{
    res.json(a)
     }   
})
})
//////////////////////////////////////////////////////////
//TODO add people by, // 

app.put('/appointments/update/:id/:nummer', function(req, res){
    console.log('kalllllllllll')

appointmentId = (req.params.id).toString()
nummerId = (req.params.nummer).toString()

mAppointment.findById(appointmentId,  function(err, appoint){
    if (err){
        res.send(err)
    }
    console.log(appoint.meetup)

    if (appoint.meetup.indexOf(nummerId) > -1) {
    //In the array!
} else {
   appoint.meetup.push(nummerId)
   appoint.save(function(err){
        if(err)
            res.send(err);
    });
  
}
    res.json({msg:'stuff'})

})

})
///////////////////////////////////////////////////////

app.get('/appointments/arrived/:id/:number', function(req,res){
    
    appointmentId = (req.params.id).toString()
    nummerId = (req.params.number).toString()
    console.log(appointmentId, nummerId)
    var presence = 0
    mAppointment.findById(appointmentId, function(err, appoint){
    if (err){
        res.send(err)
    }
console.log(appoint.meetup)
res.json(appoint.meetup)
})
})

///////////////////////////////

app.get('/', function(req,res){
    console.log('getting')
    
    var b = 
    {
        name : 'johannes'
    }

    res.json(b)
})


app.post('/users', function(req, res){
    console.log('hei')
    
    var b = new mUser({
        name: req.body.name,
        surname: req.body.surname,
        email : req.body.email,
        number : req.body.number,
        currency : req.body.currency
    });
    b.save(function(err, b ){
        if(err) return res.status(500).send('error, dbError. ');
        res.json({id: b._id});
    })
})

////////////////////////////////////////////////////////
app.get('/appointments/:id/settlement', function(req,res){
    //start meeting
    appointmentId = (req.params.id).toString()

    
    mAppointment.findById(appointmentId, function(err, appoint){
        if (err){
            res.send('err')
        }

        if(appoint.settlementId != ""){
            mSettlement.findById(appoint.settlementId, function(err, settle){
                if(err){
                    res.send('err')
                }
                res.json({id:appoint.settlementId, summary: settle.summary})
            })


        }else{
            console.log('doing thisssssssssssssssssssssss')



        var summary1 = [] 
        var diff = arr_diff(appoint.meetup, appoint.attendees) 
        if (diff.length > 0 ){
            for(var i = 0; i < diff.length; i++){
                for(var j = 0; j < appoint.attendees.length; j++){   
                    if(!in_arr(appoint.meetup,appoint.attendees[j])){
                        break;
                    }
                    summary1.push({from: diff[i], to:appoint.attendees[j], ammount: appoint.punishment, settled: false})
            }
            }
        }

                    console.log(summary1)
                        var settlment = new mSettlement({
                        appointmentId : appointmentId,
                        summary : summary1
                    })

                     settlment.save(function(err, b ){
                    /////////////////7
                    appoint.settlementId = b._id
                    appoint.save()
                    if(err) return res.status(500).send('error, dbError. ');
                    res.json({id:b._id, summary:summary1});
                     })

    }
    })

    function in_arr(a1,element){
        var isInn = false
  if (a1.indexOf(element) > -1) {
    //In the array!
    isInn = true
    } 
        return isInn
    }

    function arr_diff (a2, a1) {

    var a = [], diff = [];

    for (var i = 0; i < a1.length; i++) {
        a[a1[i]] = true;
    }

    for (var i = 0; i < a2.length; i++) {
        if (a[a2[i]]) {
            delete a[a2[i]];
        } else {
            a[a2[i]] = true;
        }
    }

    for (var k in a) {
        diff.push(k);
    }

    return diff;
};

    

    //


})
/////////////////////////////////////////////////////

//////////updating fields in the settlement/////////
app.post('/settlements/:id/update', function(req, res){
console.log(req.body)
var settleId = req.params.id.toString()

mSettlement.findById(settleId, function(err, settlement){
    if(err){
        res.send('err')
    }
    settlement.summary = req.body.summary
})
res.status(200)
res.send('succsess')
})




///////////////////////////////////////////////////////

var server;
function startServer() {
    server = http.createServer(app).listen(app.get('port'), function(){
      console.log( 'Express started in ' + app.get('env') +
        ' mode on http://localhost:' + app.get('port') +
        '; press Ctrl-C to terminate.' );
    });

    switch(app.get('env')){
    case 'development':
    db.connect(credentials.mongo.development.connectionstring,opts);
    break;
    case 'production':
    db.connect(credentials.mongo.production.connectionstring,opts);
    default:
    throw new Error('Unkown err: ' + app.get('env'));
}
}




if(require.main === module){
    // application run directly; start app server
    startServer();
} else {
    // application imported as a module via "require": export function to create server
    module.exports = startServer;
}