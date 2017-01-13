import React, {Component} from "react"
import Message from "./Message"

export default class MessageList extends Component {
  constructor() {
    super()
    this.state = {messages: []}
  }

  componentWillMount() {
    let {channel} = this.props

    channel.on("msg_history", ({messages: msgs}) => {
      this.pushMessages(msgs)
    })

    channel.on("new_msg", msg => {
      this.pushMessages([msg])
    })
  }

  pushMessages(msgs) {
    this.setState({messages: this.state.messages.concat(msgs)})
    let list = document.getElementById("message-list")
    list.scrollTop = list.scrollHeight
  }

  handleSubmit({key, target}) {
    if (key !== "Enter") { return }

    let {channel} = this.props
    let onSuccess = (msg) => {
      target.disabled = false
      target.value = ""
    }
    let onError = () => {
      target.disabled = false
    }

    target.disabled = true

    channel.push("new_msg", {body: target.value})
      .receive("ok", onSuccess)
      .receive("error", onError)
      .receive("timeout", onError)
  }

  render() {
    let messages = (
      <ul className="list-group">
        {this.state.messages.map(msg => <Message key={msg.id} message={msg} />)}
      </ul>
    )

    return(
      <div id="message-list" className="panel panel-default">
        {messages}
        <div className="panel-footer">
          <input
            value={this.state.body}
            onKeyPress={(e) => this.handleSubmit(e)}
            id="btn-input"
            type="text"
            className="form-control"
            placeholder="Send message..."
          />
        </div>
      </div>
    )
  }
}
