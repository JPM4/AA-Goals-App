# == Schema Information
#
# Table name: goals
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  body       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  priv       :boolean
#  status     :string
#

class Goal < ActiveRecord::Base
  validates_presence_of :user, :body
  validates :priv, :inclusion => {:in => [true, false]}
  validates :status, :inclusion => {:in => ["Complete", "Incomplete"]}
  after_initialize :ensure_status

  belongs_to :user

  def ensure_status
    self.status ||= "Incomplete"
  end

  # def priv=(arg)
  #   puts arg
  #   @priv = 't' if arg == "true"
  #   @priv = 'f' if arg == "false"
  # end
end
