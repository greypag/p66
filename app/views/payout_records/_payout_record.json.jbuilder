json.extract! payout_record, :id, :created_at, :updated_at
json.url payout_record_url(payout_record, format: :json)
