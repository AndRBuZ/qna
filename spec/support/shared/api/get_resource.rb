shared_examples_for 'GET resource' do
  before { get api_path, params: { access_token: access_token.token }, headers: headers }

  it 'returns 200 status' do
    expect(response).to be_successful
  end

  it 'returns all public fields' do
    public_fields.each do |attr|
      expect(resource_response[attr]).to eq resource.send(attr).as_json
    end
  end

  context 'comments' do
    let(:comment) { resource.comments.first }
    let(:comment_response) { resource_response['comments'].first }

    it 'return list of comments' do
      expect(resource_response['comments'].size).to eq 3
    end

    it 'return all public fields' do
      %w[id body commentable_type commentable_id created_at updated_at].each do |attr|
        expect(comment_response[attr]).to eq comment.send(attr).as_json
      end
    end
  end

  context 'links' do
    let(:link) { resource.links.first }
    let(:link_response) { resource_response['links'].first }

    it 'return list of links' do
      expect(resource_response['links'].size).to eq 3
    end

    it 'return all public fields' do
      %w[id name url linkable_type linkable_id created_at updated_at].each do |attr|
        expect(link_response[attr]).to eq link.send(attr).as_json
      end
    end
  end

  context 'files' do
    it 'return list of files' do
      expect(resource_response['files'].size).to eq 2
    end
  end
end