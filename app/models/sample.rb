class Sample
  include ActiveModel::Model

  attr_accessor :url

  validates :url, presence: true

  def issues
    csv = `octrouble issues`
  end
end
