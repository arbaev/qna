module LinksHelper
  def link_and_gist(link)
    link_tag = link_to link.name, link.url

    if link.url.include?('gist.github.com')
      client = Octokit::Client.new
      gist = client.gist(link.url.split('/').last)
      link_tag + gist.files.reduce('<br>') do |acc, file|
        g = file.last
        acc += "<em>#{g.filename}</em><br><pre>#{g.content}</pre><br>"
      end.html_safe
    else
      link_tag
    end
  end
end
