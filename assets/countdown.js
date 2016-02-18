function countdown(timeframe, container){
  second    = 60
  date      = new Date()
  time      = date.getMinutes() * second + date.getSeconds()
  expiry    = second * timeframe
  timeleft  = expiry - time % expiry // let's say 01:30, then current seconds is 90, 90%300 = 90, then 300-90 = 210. That's the time left!
  result    = window.parseInt(timeleft / second) + ":" + timeleft % second

  container.innerHTML = result
}

container = document.getElementById("countdown")

function checkTimeoutValue(){
  window.setTimeout(function(){
    if (isNaN(window.topicTimeframe)) {
      checkTimeoutValue()
    } else {
      window.setInterval(countdown, 500, window.topicTimeframe, container)
    }
  }, 100)
}

checkTimeoutValue()
