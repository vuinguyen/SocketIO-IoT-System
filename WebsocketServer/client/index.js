var socket = io();
var userId = "user";

/*
// Comment this out as we don't need chat capability for now
$('form').submit(function() {
    socket.emit('chat message', {value: $('#m').val(), userId: userId});
    $('#m').val('');
    return false;
});
*/

$("#led-link1").on('click', function(e){
    socket.emit('toggle led', {value: 0, userId: userId, ledId: 1, ledColor: "Green"});
});

$("#led-link2").on('click', function(e){
    socket.emit('toggle led', {value: 0, userId: userId, ledId: 2, ledColor: "Red"});
});

$("#led-link3").on('click', function(e){
    socket.emit('toggle led', {value: 0, userId: userId, ledId: 3, ledColor: "Blue"});
});

socket.on('toggle led', function(msg) {
    //console.log('ledId: ' + msg.ledId);
    var ledContainer = "#led-container" + msg.ledId;
    var ledContainerSpan = "#led-container" + msg.ledId + " span";
    var ledContainerOn = "led-container-on" + msg.ledId;
    if(msg.value === false) {
        $('#messages').prepend($('<li>Toggle LED: ' + msg.ledColor + ': OFF<span> - '+msg.userId+'</span></li>'));
        $(ledContainer).removeClass(ledContainerOn);
        $(ledContainer).addClass("led-container-off");
        $(ledContainerSpan).text("OFF");
    }
    else if(msg.value === true) {
        $('#messages').prepend($('<li>Toggle LED: ' + msg.ledColor + ': ON<span> - '+msg.userId+'</span></li>'));
        $(ledContainer).removeClass("led-container-off");
        $(ledContainer).addClass(ledContainerOn);
        $(ledContainerSpan).text("ON");
    }
});

socket.on('chat message', function(msg) {
    $('#messages').prepend($('<li>'+msg.value+'<span> - '+msg.userId+'</span></li>'));
});

socket.on('connected users', function(msg) {
    $('#user-container').html("");
    for(var i = 0; i < msg.length; i++) {
        //console.log(msg[i]+" )msg[i] == userId( "+userId);
        if(msg[i] == userId)
            $('#user-container').append($("<div id='" + msg[i] + "' class='my-circle'><span>"+msg[i]+"</span></div>"));
        else
            $('#user-container').append($("<div id='" + msg[i] + "' class='user-circle'><span>"+msg[i]+"</span></div>"));
    }
});

socket.on('user connect', function(msg) {
    if(userId === "user"){
        console.log("Client side userId: "+msg);
        userId = msg;
    }
});

socket.on('user disconnect', function(msg) {
    console.log("user disconnect: " + msg);
    var element = '#'+msg;
    console.log(element)
    $(element).remove();
});

window.onunload = function(e) {
    socket.emit("user disconnect", userId);
}