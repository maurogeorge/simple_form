# encoding: UTF-8
require 'test_helper'

class EnumTest < ActionView::TestCase

  def with_enum_for(object, *args)
    with_concat_form_for(object) do |f|
      f.enum(*args)
    end
  end

  test 'builder preloads collection association' do
    with_enum_for @user, :status
    assert_select 'form select.select#user_status'
    assert_select 'form select option[value="active"]', 'active'
    assert_select 'form select option[value="archived"]', 'archived'
  end
end
