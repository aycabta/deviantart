require 'helper'
require 'deviantart'

class DeviantArt::Client::Collections::Test < Test::Unit::TestCase
  setup do
    @da, @credentials = create_da
  end
  sub_test_case '#get_collections_folders' do
    setup do
      @username = fixture('collections-input.json').json['username']
      @collections_folders = fixture('collections_folders.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/collections/folders`,
        da: @da,
        body: @collections_folders)
    end
    test 'requests the correct resource' do
      resp = @da.get_collections_folders(username: @username, ext_preload: true)
      assert_instance_of(DeviantArt::Collections::Folders, resp)
      assert_instance_of(Array, resp.results)
      assert_instance_of(DeviantArt::Deviation, resp.results.first.deviations.first)
    end
  end
  sub_test_case '#get_collections' do
    setup do
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
    test 'requests the correct resource' do
      resp = @da.get_collections(@folderid, username: @username)
      assert_instance_of(DeviantArt::Collections, resp)
      assert_instance_of(Array, resp.results)
      assert_instance_of(DeviantArt::Deviation, resp.results.first)
    end
  end
  sub_test_case '#fave and #unfave' do
    setup do
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
    test 'requests the correct resource' do
      resp = @da.fave(@deviationid)
      assert_instance_of(DeviantArt::Collections::Fave, resp)
      assert_boolean(resp.success)
      assert_kind_of(Integer, resp.favourites)
      resp = @da.unfave(@deviationid)
      assert_instance_of(DeviantArt::Collections::Unfave, resp)
      assert_boolean(resp.success)
      assert_kind_of(Integer, resp.favourites)
    end
  end
  sub_test_case '#fave twice' do
    setup do
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
    teardown do
      stub_da_request(
        method: :post,
        url: "https://#{@da.host}/api/v1/oauth2/collections/unfave",
        da: @da,
        body: @fave)
      @da.unfave(@deviationid)
    end
    test 'requests the correct resource' do
      resp = @da.fave(@deviationid)
      assert_instance_of(DeviantArt::Error, resp)
      assert_equal(400, resp.status_code)
      assert_equal('error', resp.status)
      assert_equal('invalid_request', resp.error)
      assert_equal('Deviation is already in favourites.', resp.error_description)
    end
  end
  sub_test_case '#unfave to not #fave-ed' do
    setup do
      @deviationid = fixture('fave-input.json').json['deviationid']
      @unfave_error = fixture('unfave-error.json')
      stub_da_request(
        method: :post,
        url: "https://#{@da.host}/api/v1/oauth2/collections/unfave",
        da: @da,
        body: @unfave_error,
        status_code: 400)
    end
    test 'requests the correct resource' do
      resp = @da.unfave(@deviationid)
      assert_instance_of(DeviantArt::Error, resp)
      assert_equal(400, resp.status_code)
      assert_equal('error', resp.status)
      assert_equal('invalid_request', resp.error)
      assert_equal('Deviation is not in favourites.', resp.error_description)
    end
  end
  sub_test_case '#create_collection_folder' do
    setup do
      @create = fixture('collections_folders_create.json')
      stub_da_request(
        method: :post,
        url: "https://#{@da.host}/api/v1/oauth2/collections/folders/create",
        da: @da,
        body: @create)
    end
    test 'requests the correct resource' do
      resp = @da.create_collection_folder(@create.json['name'])
      assert_instance_of(DeviantArt::Collections::Folders::Create, resp)
      assert_instance_of(String, resp.folderid)
      assert_instance_of(String, resp.name)
    end
  end
  sub_test_case '#create_collection_folder' do
    setup do
      @validate = fixture('collections_folders_create-error_validate.json')
      stub_da_request(
        method: :post,
        url: "https://#{@da.host}/api/v1/oauth2/collections/folders/create",
        da: @da,
        body: @validate,
        status_code: 400)
    end
    test 'validation failed' do
      resp = @da.create_collection_folder(' ')
      assert_instance_of(DeviantArt::Error, resp)
      assert_equal(400, resp.status_code)
      assert_equal('invalid_request', resp.error)
      assert_equal('failed to validate folder', resp.error_details.folder)
      assert_equal('Request field validation failed.', resp.error_description)
      assert_equal('error', resp.status)
    end
  end
  sub_test_case '#create_collection_folder' do
    setup do
      @name_required = fixture('collections_folders_create-error_name_required.json')
      stub_da_request(
        method: :post,
        url: "https://#{@da.host}/api/v1/oauth2/collections/folders/create",
        da: @da,
        body: @name_required,
        status_code: 400)
    end
    test 'name required' do
      resp = @da.create_collection_folder(nil)
      assert_instance_of(DeviantArt::Error, resp)
      assert_equal(400, resp.status_code)
      assert_equal('invalid_request', resp.error)
      assert_equal('folder is required', resp.error_details.folder)
      assert_equal('Request field validation failed.', resp.error_description)
      assert_equal('error', resp.status)
    end
  end
  sub_test_case '#remove_collection_folder' do
    setup do
      @folderid = fixture('collections_folders_remove-input.json').json['folderid']
      @remove = fixture('collections_folders_remove.json')
      stub_da_request(
        method: :get,
        url: "https://#{@da.host}/api/v1/oauth2/collections/folders/remove/#{@folderid}",
        da: @da,
        body: @remove)
    end
    test 'requests the correct resource' do
      resp = @da.remove_collection_folder(@folderid)
      assert_instance_of(DeviantArt::Collections::Folders::Remove, resp)
      assert_equal(true, resp.success)
    end
  end
  sub_test_case '#remove_collection_folder' do
    setup do
      @folderid = fixture('collections_folders_remove-error-input.json').json['folderid']
      @remove = fixture('collections_folders_remove-error.json')
      stub_da_request(
        method: :get,
        url: "https://#{@da.host}/api/v1/oauth2/collections/folders/remove/#{@folderid}",
        da: @da,
        body: @remove,
        status_code: 400)
    end
    test 'validation failed' do
      resp = @da.remove_collection_folder(@folderid)
      assert_instance_of(DeviantArt::Error, resp)
      assert_equal(400, resp.status_code)
      assert_equal('invalid_request', resp.error)
      assert_equal('folderid is not a valid UUID', resp.error_details.folderid)
      assert_equal('Request field validation failed.', resp.error_description)
      assert_equal('error', resp.status)
    end
  end
  sub_test_case '#create_collection_folder and #remove_collection_folder' do
    setup do
      @create = fixture('collections_folders_create.json')
      @remove = fixture('collections_folders_remove.json')
      @collections_folders = fixture('collections_folders.json')
      stub_da_request(
        method: :post,
        url: "https://#{@da.host}/api/v1/oauth2/collections/folders/create",
        da: @da,
        body: @create)
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/collections/folders/remove/`,
        da: @da,
        body: @remove)
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/collections/folders`,
        da: @da,
        body: @collections_folders)
      resp = @da.create_collection_folder(@create.json['name'])
      @folderid = resp.folderid
      @da.remove_collection_folder(@folderid)
    end
    test 'requests the correct resource' do
      resp = @da.get_collections_folders()
      assert(resp.results.index{ |i| i.folderid == @folderid }.nil?)
    end
  end
end
