import "phoenix_html"
import socket from "./socket"
import React, {Component} from "react"
import {render} from "react-dom"
import Room from "./Room"

let el = document.getElementById("chat")

if (window.userToken) {
  socket.connect()
}

if (el) {
  render(<Room socket={socket} room={el.dataset.room} />, el)
}
