require 'json'
require 'erb'
require 'cgi'

template = <<-EOF
---
layout: download
title: "<%= id %> Download"
name: "<%= id %>"
version: "<%= attributes["version"] %>"
manufacturer: "<%= attributes["manufacturer"] %>"
downloads: "<%= attributes["downloads"] %>"
board_url: "<%= attributes["board_url"] %>"
board_image: "<%= attributes["board_image"] %>"
description: "<%= attributes["description"] %>"
files:
  <%- attributes["files"].each do |file| -%>
  "<%= file[0] %>": "<%= file[1] %>"
  <%- end -%>
permalink: "/download/<%= CGI.escape(id) %>/"
---
EOF

erb = ERB.new(template, nil, '-')

downloads = File.read('_data/downloads.json')
downloads = JSON.parse(downloads)

downloads["data"].each do |download|
  path = File.join('_downloads', "#{CGI.escape(download["id"])}.md")
  File.open(path, 'w') do |f|
    f.write erb.result_with_hash(download)
  end
end
