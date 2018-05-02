require 'rails_helper'

RSpec.describe DynamicNestedForms::ViewHelpers do
  describe '#autocomplete_to_add_item' do
    let(:patient) { create(:patient) }
    let(:physicians) { create_list(:physician, 3) }
    
    before(:each) do
      visit edit_patient_path(patient)
    end
    
    it "displays patient" do
      expect(page).to have_selector("input[value='#{patient.name}']")
    end
    
    it "displays physicians", js: true do
      fill_in "autocomplete_nested_content", with: physicians[1].name[0..2]
      expect(page).to have_selector(".ui-menu-item-wrapper", text: physicians[1].name)
    end
    
    before(:each) do
      fill_in "autocomplete_nested_content", with: physicians[1].name
    end
    
    context "before submit" do
      before(:each) do
        find(".ui-menu-item-wrapper", text: physicians[1].name).click
      end
      
      it "add physician to nested-items", js: true do
        expect(page).to have_selector(".nested-content", text: physicians[1].name)
      end
    
      it "displays only unique nested items", js: true do
        fill_in "autocomplete_nested_content", with: physicians[1].name
        expect(page).to_not have_selector(".ui-menu-item-wrapper", text: physicians[1].name)
      end
    
      it "remove physician from nested-items", js: true do
        find("a.remove-item", text: "Remove").click
        expect(page).to_not have_selector(".nested-content", text: physicians[1].name)
      end
    end
    
    context "after submit" do
      before(:each) do
        click_button "Update Patient"
        visit edit_patient_path(patient)
      end
      
      it "save nested items", js: true do
        expect(page).to_not have_selector(".nested-content", text: physicians[1].name)
      end
      
      it "not displays alredy saved nested items", js: true do
        fill_in "autocomplete_nested_content", with: physicians[1].name
        expect(page).to_not have_selector(".ui-menu-item-wrapper", text: physicians[1].name)
      end
    end
  end
end