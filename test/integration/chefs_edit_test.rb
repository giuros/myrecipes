require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create!(chefname: 'Giuseppe', email: 'giuseppe@example.com',
                        password: "password", password_confirmation: "password")
    @chef2 = Chef.create!(chefname: 'Pluto', email: 'pluto@example.com',
                        password: "password", password_confirmation: "password")
    @admin_user = Chef.create!(chefname: 'Pluto1', email: 'pluto1@example.com',
                        password: "password", password_confirmation: "password", admin: true)
  end
  
  test "reject an invalid edit" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path, params: { chef: { chefname: " ", email: "giuseppe@esempi.it" } }
    assert_template 'chefs/edit'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
  
  test "accept valid edit" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path, params: { chef: { chefname: "giuseppe1", email: "giuseppe1@esempi.it" } }
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "giuseppe1", @chef.chefname
    assert_match "giuseppe1@esempi.it", @chef.email
  end
  
  test "accept edit attempt by admin user" do
    sign_in_as(@admin_user, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: "giuseppe3", email: "giuseppe3@esempio.it" } }
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "giuseppe3", @chef.chefname
    assert_match "giuseppe3@esempio.it", @chef.email
  end
  
  test "redirect edit attempt by another non-admin user" do
    sign_in_as(@chef2, "password")
    updated_name = "pippo"
    updated_email = "pippo@esempio.it"
    patch chef_path(@chef), params: { chef: { chefname: updated_name, email: updated_email } }
    assert_redirected_to chefs_path
    assert_not flash.empty?
    @chef.reload
    assert_match "Giuseppe", @chef.chefname
    assert_match "giuseppe@example.com", @chef.email
  end
  
end
