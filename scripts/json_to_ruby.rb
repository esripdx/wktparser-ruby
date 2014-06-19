require 'JSON'

json = File.read './scripts/terminals.json'
puts JSON.load(json)
