require "rails_helper"

describe BulkDiscount, type: :model do
  describe "relations" do
    it { should belong_to :merchant }
  end

  describe "validations" do 
    it { should validate_numericality_of :quantity_threshold }
    it { should validate_numericality_of :discount }
  end
end