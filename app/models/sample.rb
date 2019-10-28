class Sample
  include ActiveModel::Model

  URL_REGEXP = /github\.com\/[\w-]+\/[\w-]+/
  REPOSITORY_REGEXP = /\A[\w-]+\/[\w-]+\z/

  attr_accessor :url
  attr_reader :message

  validates :url, presence: true

  def issues
    repo = url_check
    return message = '正しいリポジトリを指定してください' if repo.nil?

    result = `bundle exec octrouble issues #{repo}`

    if result.include?('Issue is not found.') and result[0] != '"'
      return message = "#{repo} の Issues は 0件です"

    elsif result.include?("Repository '#{repo}' is not found.") and result[0] != '"'
      return message = "#{repo} リポジトリが見つかりません"
    end

    result
  end

  private

  def url_check
    if url =~ URL_REGEXP
      repo = url.slice(URL_REGEXP).slice(11..-1)
      repo.chop if repo[-1] == '/'

    elsif url =~ REPOSITORY_REGEXP
      repo = url.slice(REPOSITORY_REGEXP)

    else
      repo = nil
    end
    repo
  end
end
