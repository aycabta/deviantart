require 'helper'
require 'deviantart'

describe DeviantArt::Client::Collections do
  before(:all) do
    @da, @credentials = create_da
  end
  describe '#get_collections_folders' do
    before do
      @username = fixture('collections-input.json').json['username']
      @collections_folders = fixture('collections_folders.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/collections/folders`,
        da: @da,
        body: @collections_folders)
    end
    it 'requests the correct resource' do
      resp = @da.get_collections_folders(username: @username, ext_preload: true)
      assert_instance_of(DeviantArt::Collections::Folders, resp)
      assert_instance_of(Array, resp.results)
      assert_instance_of(DeviantArt::Deviation, resp.results.first.deviations.first)
    end
  end
  describe '#get_collections' do
    before do
      @username = fixture('collections-input.json').json['username']
      @folderid = fixture('collections_folders.json').json['results'].find { |c|
         c['name'] == 'tuturial'
      }['folderid']
      @collections = fixture('collections.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/collections/#{@folderid}`,
        da: @da,
        body: @collections)
    end
    it 'requests the correct resource' do
      resp = @da.get_collections(@folderid, username: @username)
      assert_instance_of(DeviantArt::Collections, resp)
      assert_instance_of(Array, resp.results)
      assert_instance_of(DeviantArt::Deviation, resp.results.first)
    end
  end
  describe '#fave and #unfave' do
    before do
      @deviationid = fixture('fave-input.json').json['deviationid']
      @fave = fixture('fave.json')
      stub_da_request(
        method: :post,
        url: "https://#{@da.host}/api/v1/oauth2/collections/fave",
        da: @da,
        body: @fave)
      stub_da_request(
        method: :post,
        url: "https://#{@da.host}/api/v1/oauth2/collections/unfave",
        da: @da,
        body: @fave)
    end
    it 'requests the correct resource' do
      resp = @da.fave(@deviationid)
      assert_instance_of(DeviantArt::Collections::Fave, resp)
      assert_includes([true, false], resp.success)
      assert_kind_of(Integer, resp.favourites)
      resp = @da.unfave(@deviationid)
      assert_instance_of(DeviantArt::Collections::Unfave, resp)
      assert_includes([true, false], resp.success)
      assert_kind_of(Integer, resp.favourites)
    end
  end
  describe '#fave twice' do
    before do
      @deviationid = fixture('fave-input.json').json['deviationid']
      @fave = fixture('fave.json')
      @fave_error = fixture('fave-error.json')
      stub_da_request(
        method: :post,
        url: "https://#{@da.host}/api/v1/oauth2/collections/fave",
        da: @da,
        body: @fave)
      @da.fave(@deviationid)
      stub_da_request(
        method: :post,
        url: "https://#{@da.host}/api/v1/oauth2/collections/fave",
        da: @da,
        body: @fave_error,
        status_code: 400)
    end
    after do
      stub_da_request(
        method: :post,
        url: "https://#{@da.host}/api/v1/oauth2/collections/unfave",
        da: @da,
        body: @fave)
      @da.unfave(@deviationid)
    end
    it 'requests the correct resource' do
      resp = @da.fave(@deviationid)
      assert_instance_of(DeviantArt::Error, resp)
      assert_equal(400, resp.status_code)
      assert_equal('error', resp.status)
      assert_equal('invalid_request', resp.error)
      assert_equal('Deviation is already in favourites.', resp.error_description)
    end
  end
  describe '#unfave to not #fave-ed' do
    before do
      @deviationid = fixture('fave-input.json').json['deviationid']
      @unfave_error = fixture('unfave-error.json')
      stub_da_request(
        method: :post,
        url: "https://#{@da.host}/api/v1/oauth2/collections/unfave",
        da: @da,
        body: @unfave_error,
        status_code: 400)
    end
    it 'requests the correct resource' do
      resp = @da.unfave(@deviationid)
      assert_instance_of(DeviantArt::Error, resp)
      assert_equal(400, resp.status_code)
      assert_equal('error', resp.status)
      assert_equal('invalid_request', resp.error)
      assert_equal('Deviation is not in favourites.', resp.error_description)
    end
  end
  describe '#create_collection_folder' do
    before do
      @create = fixture('collections_folders_create.json')
      stub_da_request(
        method: :post,
        url: "https://#{@da.host}/api/v1/oauth2/collections/folders/create",
        da: @da,
        body: @create)
    end
    it 'requests the correct resource' do
      resp = @da.create_collection_folder(@create.json['name'])
      assert_instance_of(DeviantArt::Collections::Folders::Create, resp)
      assert_instance_of(String, resp.folderid)
      assert_instance_of(String, resp.name)
    end
  end
  describe '#create_collection_folder' do
    before do
      @validate = fixture('collections_folders_create-error_validate.json')
      stub_da_request(
        method: :post,
        url: "https://#{@da.host}/api/v1/oauth2/collections/folders/create",
        da: @da,
        body: @validate,
        status_code: 400)
    end
    it 'validation failed' do
      resp = @da.create_collection_folder(' ')
      assert_instance_of(DeviantArt::Error, resp)
      assert_equal(400, resp.status_code)
      assert_equal('invalid_request', resp.error)
      assert_equal('failed to validate folder', resp.error_details.folder)
      assert_equal('Request field validation failed.', resp.error_description)
      assert_equal('error', resp.status)
    end
  end
  describe '#remove_collection_folder' do
    before do
      @folderid = fixture('collections_folders_remove-input.json').json['folderid']
      @remove = fixture('collections_folders_remove.json')
      stub_da_request(
        method: :get,
        url: "https://#{@da.host}/api/v1/oauth2/collections/folders/remove/#{@folderid}",
        da: @da,
        body: @remove)
    end
    it 'requests the correct resource' do
      resp = @da.remove_collection_folder(@folderid)
      assert_instance_of(DeviantArt::Collections::Folders::Remove, resp)
      assert_equal(true, resp.success)
    end
  end
  describe '#remove_collection_folder' do
    before do
      @folderid = fixture('collections_folders_remove-error-input.json').json['folderid']
      @remove = fixture('collections_folders_remove-error.json')
      stub_da_request(
        method: :get,
        url: "https://#{@da.host}/api/v1/oauth2/collections/folders/remove/#{@folderid}",
        da: @da,
        body: @remove,
        status_code: 400)
    end
    it 'validation failed' do
      resp = @da.remove_collection_folder(@folderid)
      assert_instance_of(DeviantArt::Error, resp)
      assert_equal(400, resp.status_code)
      assert_equal('invalid_request', resp.error)
      assert_equal('folderid is not a valid UUID', resp.error_details.folderid)
      assert_equal('Request field validation failed.', resp.error_description)
      assert_equal('error', resp.status)
    end
  end
end
