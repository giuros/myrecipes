require 'test_helper'

class ChefsListingTest < ActionDispatch::IntegrationTest
  
  def setup
    @chef = Chef.create!(chefname: 'Pippo', email: 'pippo@example.com',
                        password: "password", password_confirmation: "password")
    @chef2 = Chef.create!(chefname: 'Pluto', email: 'pluto@example.com',
                        password: "password", password_confirmation: "password")
  end
  
  test "should get chefs listing" do
    get chefs_path
    assert_template 'chefs/index'
    assert_match @chef.chefname, response.body
    assert_select "a[href=?]", chef_path(@chef), text: @chef.chefname.capitalize
    assert_select "a[href=?]", chef_path(@chef2), text: @chef2.chefname.capitalize
  end
  
end
