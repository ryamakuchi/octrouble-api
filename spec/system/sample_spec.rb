# frozen_string_literal: true

describe 'Sample', type: :system do
  it 'Get Issues rails/rails' do
    visit root_path
    fill_in 'url', with: 'rails/rails'
    click_button 'Search'
    expect(page).to have_content 'rails/rails の検索結果'
  end
end
