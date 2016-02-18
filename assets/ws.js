function log(msg){
  console.log("socket state: %s (%s)", socket.readyState, msg)
}

function connect(host){
  return new WebSocket(host)
}

function send(msg) {
  socket.send(msg)
}

socket = connect("ws://localhost:9292")

socket.onopen = function(){
  log("open")
}

socket.onclose = function(){
  log("close")
}

socket.onmessage = function(msg){
  json = JSON.parse(msg.data)

  if ("topic_timeframe" in json) {
    window.topicTimeframe = json.topic_timeframe
  }

  log(msg)
}

yes = document.getElementById("yes")
no  = document.getElementById("no")

yes.onclick = function(){
  send(this.innerHTML)
}

no.onclick = function(){
  send(this.innerHTML)
}