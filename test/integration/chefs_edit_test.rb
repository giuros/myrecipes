require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create!(chefname: 'Giuseppe', email: 'giuseppe@example.com',
                        password: "password", password_confirmation: "password")
  end
  
  test "reject an invalid edit" do
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path, params: { chef: { chefname: " ", email: "giuseppe@esempi.it" } }
    assert_template 'chefs/edit'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
  
  test "accept valid signup" do
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path, params: { chef: { chefname: "giuseppe1", email: "giuseppe1@esempi.it" } }
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "giuseppe1", @chef.chefname
    assert_match "giuseppe1@esempi.it", @chef.email
  end
end
