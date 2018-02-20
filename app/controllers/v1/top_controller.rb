module V1
  class TopController < ApiController
    def index

      @spin_starred = Spin.select('id','full_name','stargazers_count').order('stargazers_count DESC').limit(10)
      @spin_watched = Spin.select('id','full_name','watchers_count').order('watchers_count DESC').limit(10)
      @spin_downloaded= Spin.select('id','full_name','downloads_count').order('downloads_count DESC').limit(10)

      @top_tags = Tag.joins(:spins).group("name","id").order('count_id DESC').count("id")
      @top_contributors = User.joins(:spins).group("github_login","id").order('count_id DESC').count("id")
      @newest_spins = Spin.select("id","full_name","created_at").order('created_at DESC').limit(10)

      most_starred = []
      @spin_starred.each do |spin|
        most_starred = most_starred.push({ "name": spin.full_name, "Stars": spin.stargazers_count, "id": spin.id })
      end

      most_watched = []
      @spin_watched.each do |spin|
        most_watched = most_watched.push({ "name": spin.full_name, "Watchers": spin.watchers_count, "id": spin.id })
      end

      most_download = []
      @spin_downloaded.each do |spin|
        most_download = most_download.push({ "name": spin.full_name, "Downloads": spin.downloads_count, "id": spin.id })
      end

      top_tags = []
      @top_tags.each do |tag, count|
        break if top_tags.count == 10
        top_tags = top_tags.push({ "name": tag.first, "# Spins": count, "id": tag.second })
      end

      top_contributors = []
      @top_contributors.each do |user, count|
        break if top_contributors.count == 10
        top_contributors = top_contributors.push({ "name": user.first, "# Spins": count, "id": user.second })
      end

      newest = []
      @newest_spins.each do |user|
        newest = newest.push({ "name": user.full_name, "Added on": user.created_at, "id": user.id })
      end

      response = {
        "data": {
          "Most Starred": most_starred,
          "Most Watched": most_watched,
          "Most Downloaded": most_download,
          "Top Tags": top_tags,
          "Top Contributors": top_contributors,
          "Newest": newest
        }
      }

      return_response response, :ok, {}
    end
  end
end