shared_examples_for 'GET collection' do
  before { get api_path, params: { access_token: access_token.token }, headers: headers }

  it 'returns 200 status' do
    expect(response).to be_successful
  end

  it 'returns all public fields' do
    public_fields.each do |attr|
      expect(resource_response[attr]).to eq resource.send(attr).as_json
    end
  end

  it 'contains user object' do
    expect(resource_response['user']['id']).to eq resource.user.id
  end
end
