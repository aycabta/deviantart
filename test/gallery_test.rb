require 'helper'
require 'deviantart'

class DeviantArt::Client::Gallery::Test < Test::Unit::TestCase
  setup do
    @da, @credentials = create_da
  end
  sub_test_case '#get_gallery_all' do
    setup do
      @username = fixture('gallery-input.json').json['username']
      @gallery_all = fixture('gallery_all.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/gallery/all`,
        da: @da,
        body: @gallery_all)
    end
    test 'requests the correct resource' do
      resp = @da.get_gallery_all(username: @username)
      assert_instance_of(DeviantArt::Gallery::All, resp)
      assert_instance_of(Array, resp.results)
      assert_instance_of(DeviantArt::Deviation, resp.results.first)
    end
  end
  sub_test_case '#get_gallery_folders' do
    setup do
      @username = fixture('gallery-input.json').json['username']
      @gallery_folders = fixture('gallery_folders.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/gallery/folders`,
        da: @da,
        body: @gallery_folders)
    end
    test 'requests the correct resource' do
      resp = @da.get_gallery_folders(username: @username, calculate_size: true, ext_preload: true)
      assert_instance_of(DeviantArt::Gallery::Folders, resp)
      assert_instance_of(Array, resp.results)
      assert_instance_of(DeviantArt::Deviation, resp.results.first.deviations.first)
    end
  end
  sub_test_case '#get_gallery' do
    setup do
      gallery_input = fixture('gallery-input.json').json
      @username = gallery_input['username']
      @folderid = gallery_input['folderid']
      @gallery = fixture('gallery.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/gallery/#{@folderid}`,
        da: @da,
        body: @gallery)
    end
    test 'requests the correct resource' do
      resp = @da.get_gallery(username: @username, folderid: @folderid)
      assert_instance_of(DeviantArt::Gallery, resp)
      assert_instance_of(Array, resp.results)
      assert_instance_of(DeviantArt::Deviation, resp.results.first)
    end
  end
  sub_test_case '#create_gallery_folder' do
    setup do
      @foldername = fixture('gallery_folders_create-input.json').json['folder']
      @folder = fixture('gallery_folders_create.json')
      stub_da_request(
        method: :post,
        url: "https://#{@da.host}/api/v1/oauth2/gallery/folders/create",
        da: @da,
        body: @folder)
    end
    test 'requests the correct resource' do
      resp = @da.create_gallery_folder(@foldername)
      assert_instance_of(DeviantArt::Gallery::Folders::Create, resp)
      assert_instance_of(String, resp.folderid)
      assert_equal(@foldername, resp.name)
    end
  end
  sub_test_case '#create_gallery_folder' do
    setup do
      @folder = fixture('gallery_folders_create-folder_is_required.json')
      stub_da_request(
        method: :post,
        url: "https://#{@da.host}/api/v1/oauth2/gallery/folders/create",
        da: @da,
        body: @folder,
        status_code: 400)
    end
    test 'requires folder' do
      resp = @da.create_gallery_folder(nil)
      assert_instance_of(DeviantArt::Error, resp)
      assert_equal('invalid_request', resp.error)
      assert_equal('Request field validation failed.', resp.error_description)
      assert_equal('folder is required', resp.error_details.folder)
      assert_equal('error', resp.status)
      assert_equal(400, resp.status_code)
    end
  end
  sub_test_case '#create_gallery_folder' do
    setup do
      @folder = fixture('gallery_folders_create-failed_to_validate_folder.json')
      stub_da_request(
        method: :post,
        url: "https://#{@da.host}/api/v1/oauth2/gallery/folders/create",
        da: @da,
        body: @folder,
        status_code: 400)
    end
    test 'failed to validate folder' do
      resp = @da.create_gallery_folder('')
      assert_instance_of(DeviantArt::Error, resp)
      assert_equal('invalid_request', resp.error)
      assert_equal('Request field validation failed.', resp.error_description)
      assert_equal('failed to validate folder', resp.error_details.folder)
      assert_equal('error', resp.status)
      assert_equal(400, resp.status_code)
    end
  end
  sub_test_case '#remove_gallery_folder' do
    setup do
      @folderid = fixture('gallery_folders_remove-input.json').json['folderid']
      @folder = fixture('gallery_folders_remove.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/gallery/folders/remove/`,
        da: @da,
        body: @folder)
    end
    test 'requests the correct resource' do
      resp = @da.remove_gallery_folder(@folderid)
      assert_instance_of(DeviantArt::Gallery::Folders::Remove, resp)
      assert_equal(true, resp.success)
    end
  end
  sub_test_case '#remove_gallery_folder' do
    setup do
      @gallery_folders = fixture('gallery_folders.json')
      @remove = fixture('gallery_folders_remove-failed_to_remove_top_folder.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/gallery/folders`,
        da: @da,
        body: @gallery_folders)
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/gallery/folders/remove/`,
        da: @da,
        body: @remove,
        status_code: 500)
    end
    test 'failed to remove parent' do
      top_folder = @da.get_gallery_folders.results.find { |f| f.parent.nil? }
      resp = @da.remove_gallery_folder(top_folder.folderid)
      assert_instance_of(DeviantArt::Error, resp)
      assert_equal('server_error', resp.error)
      assert_equal('Internal Server Error.', resp.error_description)
      assert_equal('error', resp.status)
      assert_equal(500, resp.status_code)
    end
  end
end
