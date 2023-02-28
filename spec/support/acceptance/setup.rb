# frozen_string_literal: true

script = <<~SH
  ip link add name test link eth0 type dummy
SH

script.split("\n").each do |line|
  shell(line)
end
