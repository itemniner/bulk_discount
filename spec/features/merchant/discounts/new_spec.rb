require 'rails_helper'

RSpec.describe "As a merchant", type: :feature do
  describe "when I visit my dashboard" do
    before :each do
      @merchant = create(:random_merchant)
      @merchant_employee = create(:merchant_user, merchant: @merchant)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)
    end

    it "can add a discount" do
      visit "/merchant"

      click_on "Add Bulk Discount"

      expect(current_path).to eq("/merchant/#{@merchant.id}/discounts/new")

      fill_in :name, with: "10% Discount!"
      fill_in :percentage, with: 10
      fill_in :min_items, with: 10
      fill_in :description, with: "If you buy 10 items or more you get 10% off each items from this merchant"

      click_on "Submit"

      new_discount = Discount.last

      expect(current_path).to eq("/merchant/discounts")
      expect(new_discount.name).to eq("10% Discount!")
      expect(page).to have_content(new_discount.name)
      expect(page).to have_content("Discount %: 10")
      expect(page).to have_content("If items exceeds: 10")
      expect(page).to have_content(new_discount.description)
    end
  end
end