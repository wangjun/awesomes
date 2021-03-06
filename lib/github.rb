class Github
  def  self.mem_sync_repo mem
    require 'rest-client' 
    _response = RestClient.get "https://api.github.com/users/#{mem.mem_info.github}/repos?page=1&per_page=5"
    _result = JSON.parse(_response.body) 
    MemRepo.where({:mem_id=> mem.id}).delete_all
    _result.each do |item|
      mem.mem_repos << MemRepo.create({
        :name=> item['name'],
        :html_url=> item['html_url'],
        :description=> item['description'],
        :stargazers_count=> item['stargazers_count']
      })
    end
  end

  def self.sync_repo_attr repo
    _url = repo.html_url
    _api_url = "https://api.github.com/repos#{_url.split(/http(s)?:\/\/github.com/).last}?client_id=#{ENV['GITHUB_CLIENT_ID']}&client_secret=#{ENV['GITHUB_CLIENT_SECRET']}"
    
    require 'rest-client'
    _response = RestClient.get _api_url
    _result = JSON.parse(_response.body)
    _para = {
      :stargazers_count=> _result['stargazers_count'],
      :forks_count=> _result['forks_count'],
      :subscribers_count=> _result['subscribers_count'],
      :pushed_at=> _result['pushed_at'],
    }
    repo.update_attributes(_para)
  end
end
