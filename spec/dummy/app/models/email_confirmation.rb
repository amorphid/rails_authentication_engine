class EmailConfirmation < ActiveRecord::Base
  belongs_to :user
end
