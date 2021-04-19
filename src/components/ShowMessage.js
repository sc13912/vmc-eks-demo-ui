import React from "react";
import Message from "./Message";

export default function ShowMessages({messages, messagesLoaded}) {
  function getMessages() {
    if (messagesLoaded) {
        return messages.map(function(msgItem, i) {
            return <Message key={i} msgItem={msgItem} />;
          });
    } else {
      return <div>Loading...</div>;
    }
  }

  return (
    <div className="msgsC">
      <h2 style={{ color: 'blue' }}>Guest Messages</h2>
      {getMessages()}
    </div>
  );
}
