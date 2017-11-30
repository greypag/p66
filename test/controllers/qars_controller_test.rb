require 'test_helper'

class QarsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @qar = qars(:one)
  end

  test "should get index" do
    get qars_url
    assert_response :success
  end

  test "should get new" do
    get new_qar_url
    assert_response :success
  end

  test "should create qar" do
    assert_difference('Qar.count') do
      post qars_url, params: { qar: {  } }
    end

    assert_redirected_to qar_url(Qar.last)
  end

  test "should show qar" do
    get qar_url(@qar)
    assert_response :success
  end

  test "should get edit" do
    get edit_qar_url(@qar)
    assert_response :success
  end

  test "should update qar" do
    patch qar_url(@qar), params: { qar: {  } }
    assert_redirected_to qar_url(@qar)
  end

  test "should destroy qar" do
    assert_difference('Qar.count', -1) do
      delete qar_url(@qar)
    end

    assert_redirected_to qars_url
  end
end
