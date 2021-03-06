# frozen_string_literal: true

class Sample
  include ActiveModel::Model

  URL_REGEXP = %r{github\.com/[\w-]+/[\w-]+}.freeze
  REPOSITORY_REGEXP = %r{\A[\w-]+/[\w-]+\z}.freeze

  attr_reader :message

  def issues(url)
    repo = url_check(url)
    if repo.nil?
      @message = 'GitHub URL もしくは user/repo という形式で検索してください'
      return nil
    end

    result = get_issues(repo)
    message_check(result, repo)
    result
  end

  private

  def url_check(url)
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

  def message_check(result, repo)
    if result.include?('Issue is not found.') && result[0] != '"'
      @message = "#{repo} の Issues は 0件です"

    elsif result.include?("Repository '#{repo}' is not found.") && result[0] != '"'
      @message = "#{repo} リポジトリが見つかりません"
    end
  end

  def get_issues(repo)
    `bundle exec octrouble issues #{repo}`
  end
end
