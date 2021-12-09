require "socket"

port = 3000
server = TCPServer.open(port)

loop do
  # Wait for connection
  socket = server.accept

  puts "Got a connection!"
  
  if match = socket.gets.chomp.match(/^(?<verb>[A-Z]*) (?<path>[^ ]*) (?<ver>.*)$/)
    headers = []
    while line = socket.gets.chomp
      break if line.bytesize == 0
      headers << line.split(": ")
    end

    p VERB: match[:verb]
    p PATH: match[:path]
    p VERSION: match[:ver]
    p HEADERS: headers
  end

  if line.bytesize == 0
    socket.write "HTTP/1.1 200 OK\r\n"
    socket.write "Hello World!\r\n"
    socket.close
  end
end