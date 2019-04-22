require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }

  it { should validate_presence_of(:body) }
  it { should have_db_column(:best).of_type(:boolean) }
end
