require 'test_helper'

class PayoutRecordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @payout_record = payout_records(:one)
  end

  test "should get index" do
    get payout_records_url
    assert_response :success
  end

  test "should get new" do
    get new_payout_record_url
    assert_response :success
  end

  test "should create payout_record" do
    assert_difference('PayoutRecord.count') do
      post payout_records_url, params: { payout_record: {  } }
    end

    assert_redirected_to payout_record_url(PayoutRecord.last)
  end

  test "should show payout_record" do
    get payout_record_url(@payout_record)
    assert_response :success
  end

  test "should get edit" do
    get edit_payout_record_url(@payout_record)
    assert_response :success
  end

  test "should update payout_record" do
    patch payout_record_url(@payout_record), params: { payout_record: {  } }
    assert_redirected_to payout_record_url(@payout_record)
  end

  test "should destroy payout_record" do
    assert_difference('PayoutRecord.count', -1) do
      delete payout_record_url(@payout_record)
    end

    assert_redirected_to payout_records_url
  end
end
