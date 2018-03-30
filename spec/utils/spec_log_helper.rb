# frozen_string_literal: true

def puts_msg_with_separator(msg)
  msg = '## ' + msg + ' ##'
  puts "\n" + '#' * msg.length
  puts msg
  puts '#' * msg.length + "\n\n"
end
