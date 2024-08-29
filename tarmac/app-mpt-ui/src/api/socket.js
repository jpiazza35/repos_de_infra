export default function createSocket() {
  // TODO env var for socket server port
  const socket = new WebSocket("ws://localhost:7890/Echo");

  // TODO error handling
  socket.onopen = function () {
    console.log("WebSocket connected");
  };

  return socket;
}
