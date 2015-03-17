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

FactoryGirl.define do
  factory :goal do
    user_id 1
body "MyText"
private false
  end

end
