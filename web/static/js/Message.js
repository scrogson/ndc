import React, {Component} from "react"

export default class Message extends Component {
  constructor() {
    super()
  }

  render() {
    let {message} = this.props
    let {id, from, avatar, body} = message

    return(
      <li key={id} className="list-group-item">
        <div className="media-left">
          <img className="img-circle media-object" src={avatar} width="32" height="32" />
        </div>
        <div className="media-body">
          <div className="media-header">
            <strong>{from}</strong>
          </div>
          {body}
        </div>
      </li>
    )
  }
}
