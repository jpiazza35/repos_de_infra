<script>
  import jquery from "jquery";
  import createSocket from "api/socket.js";

  const userId = "test-user";
  const socket = createSocket(userId);

  let message = "";

  socket.onmessage = function (e) {
    console.log(e.data);
    const chat = jquery("#chat");
    chat.append(
      "<div><span class='message server-message'>" + e.data + "</span></div>",
    );
  };

  function sendMessage() {
    socket.send(message);

    const chat = jquery("#chat");
    chat.append(
      "<div><span class='message user-message'>" + message + "</span></div>",
    );
  }
</script>

<div class="card">
  <div class="card-header">Echo chat room</div>
  <div class="card-body">
    <div class="row">
      <div class="col-3">
        <div class="row g-3">
          <label for="message">Enter your message</label>
          <textarea id="message" bind:value={message} />
          <button class="btn btn-primary" on:click={sendMessage}
            >Send Message</button
          >
        </div>
      </div>
      <div class="col-9">
        <div id="chat" />
      </div>
    </div>
  </div>
</div>

<style>
  #chat {
    background-color: #e8e2dc;
    height: 100%;
    padding: 12px;
    display: flex;
    flex-direction: column;
  }
  :global(.message) {
    background-color: #e3ffd3;
    padding: 4px;
    margin: 4px 0;
    border-radius: 4px;
  }
  :global(.user-message) {
    background-color: #e3ffd3;
    float: right;
  }
  :global(.server-message) {
    background-color: #ffffff;
  }
</style>
