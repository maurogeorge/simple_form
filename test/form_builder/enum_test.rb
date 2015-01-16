# encoding: UTF-8
require 'test_helper'

class EnumTest < ActionView::TestCase

  def with_enum_for(object, *args)
    with_concat_form_for(object) do |f|
      f.enum(*args)
    end
  end

  test 'builder does not allow creating an enum input when no object exists' do
    assert_raise ArgumentError do
      with_enum_for :user, :status
    end
  end

  test 'builder does not allow creating an enum input when no enum exists' do
    assert_raise ArgumentError do
      with_enum_for @user, :not_defined_enum
    end
  end

  test 'builder creates a select for enum' do
    with_enum_for @user, :status
    assert_select 'form select.select#user_status'
    assert_select 'form select option[value="active"]', 'active'
    assert_select 'form select option[value="archived"]', 'archived'
  end

  test 'builder creates blank select if collection is nil' do
    with_enum_for @user, :status, collection: nil
    assert_select 'form select.select#user_status'
    assert_no_select 'form select option[value="active"]', 'active'
  end

  test 'builder allows collection radio for enum' do
    with_enum_for @user, :status, as: :radio_buttons
    assert_select 'form input.radio_buttons#user_status_active'
    assert_select 'form input.radio_buttons#user_status_archived'
  end

  test 'builder marks the enum which already belongs to the user for select' do
    @user.status = 'active'
    with_enum_for @user, :status
    assert_select 'form select option[value="active"][selected=selected]'
    assert_no_select 'form select option[value="archived"][selected=selected]'
  end

  test 'builder marks the enum which already belongs to the user for radio buttons' do
    @user.status = 'active'
    with_enum_for @user, :status, as: :radio_buttons
    assert_select 'form input.radio_buttons#user_status_active[checked=checked]'
    assert_no_select 'form input.radio_buttons#user_status_archived[checked=checked]'
  end

  test 'builder marks the enum which already belongs to the user for check boxes' do
    @user.status = 'active'
    with_enum_for @user, :status, as: :check_boxes
    assert_select 'form input.check_boxes#user_status_active[checked=checked]'
    assert_no_select 'form input.check_boxes#user_status_archived[checked=checked]'
  end

  test 'builder with collection support giving collection and item wrapper tags' do
    with_enum_for @user, :status, as: :check_boxes,
      collection_wrapper_tag: :ul, item_wrapper_tag: :li

    assert_select 'form ul', count: 1
    assert_select 'form ul li', count: 2
  end

  test 'builder with collection support does not change the options hash' do
    options = { as: :check_boxes, collection_wrapper_tag: :ul, item_wrapper_tag: :li}
    with_enum_for @user, :status, options

    assert_select 'form ul', count: 1
    assert_select 'form ul li', count: 2
    assert_equal({ as: :check_boxes, collection_wrapper_tag: :ul, item_wrapper_tag: :li},
                 options)
  end
end
