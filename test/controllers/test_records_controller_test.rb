require 'test_helper'

class TestRecordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @test_record = test_records(:one)
  end

  test "should get index" do
    get test_records_url
    assert_response :success
  end

  test "should get new" do
    get new_test_record_url
    assert_response :success
  end

  test "should create test_record" do
    assert_difference('TestRecord.count') do
      post test_records_url, params: { test_record: {  } }
    end

    assert_redirected_to test_record_url(TestRecord.last)
  end

  test "should show test_record" do
    get test_record_url(@test_record)
    assert_response :success
  end

  test "should get edit" do
    get edit_test_record_url(@test_record)
    assert_response :success
  end

  test "should update test_record" do
    patch test_record_url(@test_record), params: { test_record: {  } }
    assert_redirected_to test_record_url(@test_record)
  end

  test "should destroy test_record" do
    assert_difference('TestRecord.count', -1) do
      delete test_record_url(@test_record)
    end

    assert_redirected_to test_records_url
  end
end
