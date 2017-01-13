import {Presence} from "phoenix"
import React, {Component} from "react"
import {render} from "react-dom"
import MessageList from "./MessageList"

export default class Room extends Component {
  constructor() {
    super()
    this.state = {users: [], presenceState: {}}
  }

  componentWillMount() {
    let {roomName, socket} = this.props
    let channel = socket.channel(`rooms:lobby`, {})

    channel.on("presence_state", state => {
      let newPresence = Presence.syncState(this.state.presenceState, state)
      this.setState({users: Presence.list(newPresence, this.listBy), presenceState: newPresence})
    })

    channel.on("presence_diff", diff => {
      let newPresence = Presence.syncDiff(this.state.presenceState, diff)
      this.setState({users: Presence.list(newPresence, this.listBy), presenceState: newPresence})
    })

    this.setState({...this.state, channel: channel})
  }

  componentDidMount() {
    this.state.channel.join()
      .receive("ok", resp => { console.log("Joined successfully", resp) })
      .receive("error", resp => { console.log("Unable to join", resp) })
  }

  listBy(id, {metas: metas}) {
    let name = metas[0].name
    let avatar = metas[0].avatar

    return {id: id, name: name, avatar: avatar, count: metas.length}
  }

  renderUser(user) {
    return(
      <li key={user.id} className="list-group-item">
        <div className="media-left">
          <img className="img-circle media-object" src={user.avatar} width="32" height="32" />
        </div>
        <div className="media-body">
          <div className="media-header">
            <strong>{user.name}</strong>
          </div>
        </div>
      </li>
    )
  }

  render() {
    let {channel, users} = this.state

    return (
      <div>
        <ul className="col-sm-4 list-group">
          <li className="list-group-item">
            <span className="badge">{users.length}</span>
            <b>Users</b>
          </li>
          {users.map(this.renderUser)}
        </ul>
        <div className="col-sm-8">
          <MessageList channel={channel} />
        </div>
      </div>
    )
  }
}
