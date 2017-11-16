# frozen_string_literal: true

require 'spec_helper'

feature 'Editing a messageboard' do
  scenario 'succeeds' do
    messageboard = create(:messageboard)
    user = an_admin
    user.log_in

    visit thredded.messageboard_topics_path(messageboard)
    click_link I18n.t('thredded.nav.edit_messageboard')
    new_name = messageboard.name + '1'
    fill_in 'messageboard_name', with: new_name
    click_button I18n.t('thredded.messageboard.update')
    expect(page).to have_content(new_name)
  end

  scenario 'admin locks a messageboard' do
    messageboard = create(:messageboard)
    user = an_admin
    user.log_in

    visit thredded.messageboard_topics_path(messageboard)
    click_link I18n.t('thredded.nav.edit_messageboard')

    check I18n.t('thredded.messageboard.form.locked_label')
    click_button I18n.t('thredded.messageboard.update')

    visit thredded.messageboards_path
    expect(page).to have_css '.thredded--messageboard--icon'

    user_2 = regular_user
    user_2.log_in

    visit thredded.messageboard_topics_path(messageboard)
    expect(messageboard).not_to have_css('.thredded--form thredded--new-topic-form')
  end

  def regular_user
    PageObject::User.new(create(:user, name: 'joe'))
  end

  def an_admin
    PageObject::User.new(create(:user, name: 'joe-admin', admin: true))
  end
end
